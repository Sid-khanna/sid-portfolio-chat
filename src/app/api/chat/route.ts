// my-chatbot-app/src/app/api/chat/route.ts (for App Router)
// or my-chatbot-app/pages/api/chat.ts (for Pages Router)

import { NextRequest, NextResponse } from 'next/server';
// Ensure these imports are correct for your project setup
// If you are using `@langchain/openai` then StreamingTextResponse and OpenAIStream
// might need to be sourced from a utility you create, or adjust imports based on
// how your original `lib` folder handles it.
import { OpenAIStream } from '@/lib/OpenAIStream'; // Assuming this utility exists
import { StreamingTextResponse } from '@/lib/StreamingTextResponse'; // Assuming this utility exists

import OpenAI from "openai";
import { ChatOpenAI } from '@langchain/openai'; // For OpenAI models or compatible APIs
import { Neo4jGraph } from "@langchain/community/graphs/neo4j_graph";
import { PromptTemplate } from "@langchain/core/prompts";
import { StringOutputParser } from "@langchain/core/output_parsers";
import { RunnableSequence } from "@langchain/core/runnables";

// You would likely have a separate file for this or generate it
// For example, in a `getSystemPrompt.ts` file
import getSystemPrompt from './prompt';
// Assuming `projectDetails` is also in the same folder as your original file
import { projectDetails } from './projectDetails';

// Helper to look for a project alias in user message (retained from your old code)
function getProjectDetailFromMessage(message: string): string | null {
  const msg = message.toLowerCase();

  for (const entry of projectDetails) {
    for (const alias of entry.aliases) {
      if (msg.includes(alias.toLowerCase())) {
        return entry.content;
      }
    }
  }

  return null;
}

export const runtime = 'edge'; // Retained from your old code

// Initialize Neo4jGraph connection outside the handler for potential warm starts.
const neo4jGraph = new Neo4jGraph({
  url: process.env.NEO4J_URI!,
  username: process.env.NEO4J_USERNAME!,
  password: process.env.NEO4J_PASSWORD!,
  database: process.env.NEO4J_DATABASE || "neo4j", // Default to 'neo4j' if not specified
});


// Manual configuration for OpenRouter
const configuration = {
  apiKey: process.env.OPENROUTER_API_KEY!,
  baseURL: "https://openrouter.ai/api/v1", // Works if you use OpenAI-like payload
};

// Use LangChain's `ChatOpenAI` with custom fetchFn
const chatModel = new ChatOpenAI({
  configuration,
  model: "mistralai/mistral-7b-instruct",
  temperature: 0,
});

// Prompt for the LLM to analyze the user's question and extract entities/intent
const QUERY_ANALYSIS_PROMPT = PromptTemplate.fromTemplate(`
Analyze the user's question to determine their intent and extract key entities.
Prioritize extracting details related to Sid Khanna's portfolio (projects, skills, work experience, personal background, education, interests).
If the question is about a specific project, identify its name and any technologies/skills mentioned.
If it's about work experience, identify the company or role.
If it's about skills, identify the specific skill or category.
If it's about personal interests or background, identify those topics.
Output a JSON object with 'intent' (a high-level category like 'get_project_info', 'get_skill_info', 'get_work_info', 'get_personal_info', 'general_query') and an 'entities' array.
Entities should include 'name' and 'type' (e.g., 'Project', 'Skill', 'Technology', 'Company', 'Interest').

Example 1: "Tell me about your ParSight project."
Output: {{"intent": "get_project_info", "entities": [{{"name": "ParSight", "type": "Project"}}]}}

Example 2: "What machine learning skills do you have?"
Output: {{"intent": "get_skill_info", "entities": [{{"name": "Machine Learning", "type": "SkillCategory"}}]}}

Example 3: "Can you tell me about your work at Mold Masters?"
Output: {{"intent": "get_work_info", "entities": [{{"name": "Mold Masters", "type": "Company"}}]}}

Example 4: "What are your hobbies?"
Output: {{"intent": "get_personal_info", "entities": [{{"name": "hobbies", "type": "InterestCategory"}}]}}

Example 5: "Who is Sid Khanna?"
Output: {{"intent": "get_personal_info", "entities": [{{"name": "Sid Khanna", "type": "Person"}}]}}

User question: {question}
Output:
`);

// Main prompt for the LLM to generate the final answer, incorporating graph context
const FINAL_ANSWER_PROMPT = PromptTemplate.fromTemplate(`
You are a helpful AI assistant specialized in providing information about Sid Khanna's professional portfolio and personal background.
Use the following context, which includes structured knowledge graph data (entities and relationships)
and potentially relevant text snippets, to answer the user's question comprehensively and accurately.

Prioritize information from the 'Graph Context' as it provides structured and verified facts.
If the 'Relevant Text Snippets' provide additional, descriptive details, integrate them.
If you cannot find relevant information in the context, state that you don't have enough information about that specific query.
Maintain a professional, knowledgeable, and helpful tone.

--- Graph Context ---
{graph_context}

--- Relevant Text Snippets ---
{text_context}

--- User Question ---
{question}

Your answer:
`);

export async function POST(req: NextRequest) {
  try {
    const { message: question } = await req.json(); // Renamed 'message' to 'question' for consistency

    // 1. Analyze user query to determine intent and extract entities
    const analysisChain = RunnableSequence.from([
      QUERY_ANALYSIS_PROMPT,
      chatModel, // Using the configured chatModel (OpenRouter)
      new StringOutputParser(),
      (output) => {
        try {
          return JSON.parse(output);
        } catch (e) {
          console.error("Failed to parse analysis output:", output, e);
          return { intent: "general_query", entities: [] };
        }
      }
    ]);

    const analysisResult = await analysisChain.invoke({ question });
    const intent = analysisResult.intent;
    const entities = analysisResult.entities;

    let graphContext = "";
    let textContext = "";

    // Incorporate projectDetails as initial textContext if matched
    const matchedProjectText = getProjectDetailFromMessage(question);
    if (matchedProjectText) {
      textContext += `Here is official background context for the user's query:\n\n${matchedProjectText}\n\n`;
    }

    // 2. Perform Graph-based Retrieval based on intent and entities
    if (intent === "get_project_info") {
      for (const entity of entities) {
        if (entity.type === "Project" && entity.name) {
          const cypherQuery = `
            MATCH (p:Project {id: "${entity.name}"}) // Assuming 'id' property is used for unique project names
            OPTIONAL MATCH (p)-[:USES]->(t:Technology)
            OPTIONAL MATCH (p)-[:APPLIES]->(s:Skill)
            RETURN p.name AS projectName, p.description AS projectDescription,
                    COLLECT(DISTINCT t.name) AS technologies,
                    COLLECT(DISTINCT s.name) AS skills
          `;
          const result = await neo4jGraph.query(cypherQuery);
          if (result.length > 0) {
            const project = result[0];
            graphContext += `Project: ${project.projectName}\n`;
            graphContext += `Description: ${project.projectDescription}\n`;
            if (project.technologies && project.technologies.length > 0) {
                graphContext += `Technologies Used: ${project.technologies.join(', ')}\n`;
            }
            if (project.skills && project.skills.length > 0) {
                graphContext += `Skills Applied: ${project.skills.join(', ')}\n`;
            }
            graphContext += "\n";
          }
        } else if (entity.type === "Technology" || entity.type === "Skill") {
              const cypherQuery = `
                MATCH (p:Project)-[:USES|APPLIES]->(tOrS)
                WHERE tOrS.name CONTAINS "${entity.name}"
                RETURN p.name AS projectName, p.description AS projectDescription
                LIMIT 3
              `;
              const result = await neo4jGraph.query(cypherQuery);
              if (result.length > 0) {
                graphContext += `Projects related to ${entity.name}:\n`;
                result.forEach((row: any) => {
                    graphContext += `- ${row.projectName}: ${row.projectDescription.substring(0, 150)}...\n`;
                });
                graphContext += "\n";
              }
        }
      }
    }
    else if (intent === "get_skill_info") {
        const cypherQuery = `
            MATCH (s:Skill)
            RETURN s.name AS skillName, s.category AS skillCategory ORDER BY skillCategory, skillName
        `;
        const result = await neo4jGraph.query(cypherQuery);
        if (result.length > 0) {
            const categorizedSkills = result.reduce((acc: any, curr: any) => {
                const category = curr.skillCategory || "Uncategorized";
                if (!acc[category]) {
                    acc[category] = [];
                }
                acc[category].push(curr.skillName);
                return acc;
            }, {});

            graphContext += "Here are Sid's skills:\n";
            for (const category in categorizedSkills) {
                graphContext += `- ${category}:\n  ${categorizedSkills[category].join(', ')}\n`;
            }
            graphContext += "\n";
        }
    }
    else if (intent === "get_work_info") {
        for (const entity of entities) {
            if (entity.type === "Company" || entity.type === "Role") {
                const cypherQuery = `
                    MATCH (p:Person {id: 'Siddharth Khanna'})-[r:WORKED_AT|HAS_ROLE]-(target)
                    WHERE target.name CONTAINS "${entity.name}" OR target.companyName CONTAINS "${entity.name}"
                    OPTIONAL MATCH (target)-[:APPLIES]->(s:Skill)
                    OPTIONAL MATCH (target)-[:USES]->(t:Technology)
                    RETURN target.name AS roleName, target.companyName AS company, target.description AS roleDescription,
                            COLLECT(DISTINCT s.name) AS skills, COLLECT(DISTINCT t.name) AS technologies
                    LIMIT 1
                `;
                const result = await neo4jGraph.query(cypherQuery);
                if (result.length > 0) {
                    const role = result[0];
                    graphContext += `Role: ${role.roleName} at ${role.company}\n`;
                    graphContext += `Description: ${role.roleDescription}\n`;
                    if (role.skills && role.skills.length > 0) {
                        graphContext += `Skills Applied: ${role.skills.join(', ')}\n`;
                    }
                    if (role.technologies && role.technologies.length > 0) {
                        graphContext += `Technologies Used: ${role.technologies.join(', ')}\n`;
                    }
                    graphContext += "\n";
                }
            }
        }
        if (entities.length === 0) {
            const cypherQuery = `
                MATCH (p:Person {id: 'Siddharth Khanna'})-[:WORKED_AT]->(c:Company)
                OPTIONAL MATCH (c)-[:HAS_ROLE]->(r:Role)
                RETURN c.name AS companyName, r.name AS roleName, r.duration AS duration, r.description AS description
                ORDER BY r.startDate DESC
            `;
            const result = await neo4jGraph.query(cypherQuery);
            if (result.length > 0) {
                graphContext += "Here is Sid's work experience:\n";
                result.forEach((entry: any) => {
                    graphContext += `- ${entry.roleName} at ${entry.companyName} (${entry.duration})\n`;
                    graphContext += `  Description: ${entry.description.substring(0, 150)}...\n\n`;
                });
            }
        }
    }
    else if (intent === "get_personal_info") {
        const cypherQuery = `
            MATCH (p:Person {id: 'Siddharth Khanna'})
            OPTIONAL MATCH (p)-[:STUDIED_AT]->(e:Education)
            OPTIONAL MATCH (p)-[:HAS_INTEREST]->(i:Interest)
            RETURN p.name AS name, p.professionalPhilosophy AS philosophy,
                   COLLECT(DISTINCT {institution: e.institution, degree: e.degree, major: e.major}) AS education,
                   COLLECT(DISTINCT i.name) AS interests,
                   p.personalBackground AS background, p.personalValues AS values
        `;
        const result = await neo4jGraph.query(cypherQuery);
        if (result.length > 0) {
            const personal = result[0];
            graphContext += `About Sid Khanna:\n`;
            if (personal.philosophy) graphContext += `Professional Philosophy: ${personal.philosophy}\n\n`;
            if (personal.education && personal.education.length > 0) {
                graphContext += `Education:\n`;
                personal.education.forEach((edu: any) => {
                    graphContext += `- ${edu.degree} in ${edu.major} from ${edu.institution}\n`;
                });
                graphContext += "\n";
            }
            if (personal.background) graphContext += `Personal Background: ${personal.background}\n\n`;
            if (personal.interests && personal.interests.length > 0) {
                graphContext += `Interests & Hobbies: ${personal.interests.join(', ')}\n\n`;
            }
            if (personal.values) graphContext += `Personal Values & Approach: ${personal.values}\n\n`;
        }
    }
    else if (intent === "general_query" || graphContext === "") {
        graphContext += "I can provide information about Sid Khanna's projects, skills, work experience, education, and interests based on the knowledge graph.\n";
        graphContext += "Please ask a more specific question, e.g., 'What is ParSight?' or 'What are your programming skills?'";
    }

    // 3. Generate final answer using LLM
    // First, construct the messages array for the LLM
    const messages = [
      { role: 'system', content: getSystemPrompt() }, // Your base system prompt
      // Add context from graph and any matched text snippets
      { role: 'user', content: `--- Graph Context ---\n${graphContext}\n--- Relevant Text Snippets ---\n${textContext}\n--- User Question ---\n${question}` }
    ];

    // Then, call the OpenRouter API directly for streaming
    const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.OPENROUTER_API_KEY}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': process.env.NEXT_PUBLIC_VERCEL_URL || 'http://localhost:3000', // Update reference
      },
      body: JSON.stringify({
        model: 'mistralai/mistral-7b-instruct',
        messages: messages,
        stream: true,
      }),
    });

    // Check for errors from the API
    if (!response.ok) {
      const errorData = await response.json();
      console.error("OpenRouter API error:", errorData);
      throw new Error(`OpenRouter API error: ${response.status} - ${JSON.stringify(errorData)}`);
    }

    // Use your OpenAIStream utility to handle the streaming response
    const stream = await OpenAIStream(response);
    return new StreamingTextResponse(stream);

  } catch (error) {
    console.error("Error in chat API:", error);
    // Return a standard JSON error response for non-streaming errors
    return NextResponse.json({ error: "Internal Server Error", details: (error as Error).message }, { status: 500 });
  } finally {
    // It's generally good practice to close the driver when not in use,
    // but in serverless environments, connection pooling or keeping it open
    // for warm starts is often preferred. Re-evaluate based on your deployment.
    // await neo4jGraph.close();
  }
}