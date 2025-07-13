// my-chatbot-app/src/app/api/chat/route.ts

import { NextRequest, NextResponse } from 'next/server';
import { OpenAIStream } from '@/lib/OpenAIStream';
import { StreamingTextResponse } from '@/lib/StreamingTextResponse';

import { ChatOpenAI } from '@langchain/openai';
import { Neo4jGraph } from "@langchain/community/graphs/neo4j_graph";
import { PromptTemplate } from "@langchain/core/prompts";
import { StringOutputParser } from "@langchain/core/output_parsers";
import { RunnableSequence } from "@langchain/core/runnables";

import getSystemPrompt from './prompt';
import { projectDetails, ProjectEntry } from './projectDetails'; // Ensure ProjectEntry is imported

// Helper to look for a project alias in user message for projectDetails.ts content
function getProjectDetailFromMessage(message: string): string | null {
  const msg = message.toLowerCase();

  for (const entry of projectDetails as ProjectEntry[]) {
    for (const alias of entry.aliases) {
      if (msg.includes(alias.toLowerCase())) {
        return entry.content;
      }
    }
  }

  return null;
}

export const runtime = 'edge';

// Initialize Neo4jGraph connection outside the handler for potential warm starts.
const neo4jGraph = new Neo4jGraph({
  url: process.env.NEO4J_URI!,
  username: process.env.NEO4J_USERNAME!,
  password: process.env.NEO4J_PASSWORD!,
  database: process.env.NEO4J_DATABASE || "neo4j",
});

// Define the configuration for OpenRouter
const openRouterConfiguration = {
  apiKey: process.env.OPENROUTER_API_KEY!,
  baseURL: "https://openrouter.ai/api/v1", // Works if you use OpenAI-like payload
};

// Initialize your LLM for general chat and query analysis
const chatModel = new ChatOpenAI({
  configuration: openRouterConfiguration, // Use the defined configuration
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
    const { message: question } = await req.json();

    // 1. Analyze user query to determine intent and extract entities
    const analysisChain = RunnableSequence.from([
      QUERY_ANALYSIS_PROMPT,
      chatModel,
      new StringOutputParser(),
      (output) => {
        try {
          return JSON.parse(output);
        } catch (e) {
          console.error("Failed to parse analysis output:", output, e);
          // Fallback to general query if parsing fails
          return { intent: "general_query", entities: [] };
        }
      }
    ]);

    const analysisResult = await analysisChain.invoke({ question });
    const intent = analysisResult.intent;
    const entities = analysisResult.entities;

    let graphContext = "";
    let textContext = "";

    // 2. Perform Retrieval Augmented Generation (RAG)
    // 2.1. First, check projectDetails.ts for specific project aliases (high-priority text context)
    const matchedProjectText = getProjectDetailFromMessage(question);
    if (matchedProjectText) {
      textContext += `Here is official background context for the user's query:\n\n${matchedProjectText}\n\n`;
    }

    // 2.2. Then, perform Graph-based Retrieval based on intent and extracted entities
    if (intent === "get_project_info") {
      if (entities.length > 0) {
        // Case 1: Specific project(s) identified by name/id
        for (const entity of entities) {
          if (entity.type === "Project" && entity.name) {
            const cypherQuery = `
              MATCH (p:Project {id: "${entity.name}"})
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
          } else if ((entity.type === "Technology" || entity.type === "Skill") && entity.name) {
                // If a tech or skill is mentioned, find related projects
                const cypherQuery = `
                  MATCH (p:Project)-[:USES|APPLIES]->(tOrS)
                  WHERE toLower(tOrS.name) CONTAINS toLower("${entity.name}")
                  RETURN p.name AS projectName, p.description AS projectDescription
                  LIMIT 3
                `;
                const result = await neo4jGraph.query(cypherQuery);
                if (result.length > 0) {
                  graphContext += `Projects related to ${entity.name}:\n`;
                  result.forEach((row: any) => {
                      graphContext += `- ${row.projectName}: ${row.projectDescription.substring(0, Math.min(row.projectDescription.length, 150))}...\n`;
                  });
                  graphContext += "\n";
                }
          }
        }
      } else {
        // Case 2: No specific project entity, but intent is get_project_info (e.g., "list all projects")
        const cypherQuery = `
            MATCH (p:Project)
            OPTIONAL MATCH (p)-[:USES]->(t:Technology)
            OPTIONAL MATCH (p)-[:APPLIES]->(s:Skill)
            RETURN p.name AS projectName, p.description AS projectDescription,
                   COLLECT(DISTINCT t.name) AS technologies,
                   COLLECT(DISTINCT s.name) AS skills
            ORDER BY projectName
        `;
        const result = await neo4jGraph.query(cypherQuery);

        if (result.length > 0) {
            graphContext += "Here are some of Sid's projects:\n";
            result.forEach((project: any) => {
                graphContext += `Project: ${project.projectName}\n`;
                graphContext += `Description: ${project.projectDescription}\n`;
                if (project.technologies && project.technologies.length > 0) {
                    graphContext += `Technologies: ${project.technologies.join(', ')}\n`;
                }
                if (project.skills && project.skills.length > 0) {
                    graphContext += `Skills: ${project.skills.join(', ')}\n`;
                }
                graphContext += "\n";
            });
        } else {
            graphContext += "I couldn't find any project information in the knowledge graph.\n";
        }
      }

      // **Integrate Full-Text Search for Project Descriptions** (complementary to structured queries)
      // This helps catch descriptive queries that might not yield a direct entity match (fuzzy context).
      // Make sure you have a full-text index named 'projectDescriptions' on Project nodes,
      // e.g., CREATE FULLTEXT INDEX projectDescriptions FOR (p:Project) ON (p.name, p.description);
      const fullTextCypherQuery = `
          CALL db.index.fulltext.queryNodes('projectDescriptions', $question)
          YIELD node AS p, score
          WHERE score > 0.1 // Adjust threshold as needed for relevance
          RETURN p.name AS projectName, p.description AS projectDescription, score
          ORDER BY score DESC LIMIT 2
      `;
      try {
        const fullTextResults = await neo4jGraph.query(fullTextCypherQuery, { question });
        if (fullTextResults.length > 0) {
            graphContext += "\n--- Additional Project Context from Semantic Search ---\n";
            fullTextResults.forEach((project: any) => {
                graphContext += `Related Project: ${project.projectName} (Score: ${project.score.toFixed(2)})\n`;
                graphContext += `Summary: ${project.projectDescription.substring(0, Math.min(project.projectDescription.length, 200))}...\n\n`;
            });
        }
      } catch (err) {
        console.warn("Neo4j full-text index query failed (check index 'projectDescriptions' exists and is populated):", err);
      }

    }
    else if (intent === "get_skill_info") {
        let queryEntities = entities.map((e: any) => e.name);
        let cypherQuery;
        if (queryEntities.length > 0) {
            // Specific skill query
            const skillNames = queryEntities.map((name: string) => `"${name}"`).join(', ');
            cypherQuery = `
                MATCH (s:Skill) WHERE s.name IN [${skillNames}]
                OPTIONAL MATCH (s)<-[:APPLIES]-(p:Project)
                OPTIONAL MATCH (s)<-[:APPLIES]-(r:Role)
                RETURN s.name AS skillName, s.category AS skillCategory,
                       COLLECT(DISTINCT p.name) AS projects,
                       COLLECT(DISTINCT {role: r.name, company: r.companyName}) AS workExperiences
            `;
        } else {
            // General skill query (list all)
            cypherQuery = `
                MATCH (s:Skill)
                RETURN s.name AS skillName, s.category AS skillCategory ORDER BY skillCategory, skillName
            `;
        }
        const result = await neo4jGraph.query(cypherQuery);
        if (result.length > 0) {
            if (queryEntities.length > 0) {
                result.forEach((row: any) => {
                    graphContext += `Skill: ${row.skillName} (Category: ${row.skillCategory})\n`;
                    if (row.projects && row.projects.length > 0) {
                        graphContext += `  Used in Projects: ${row.projects.join(', ')}\n`;
                    }
                    if (row.workExperiences && row.workExperiences.length > 0) {
                        graphContext += `  Applied in Work: ${row.workExperiences.map((we: any) => `${we.role} at ${we.company}`).join(', ')}\n`;
                    }
                    graphContext += "\n";
                });
            } else {
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
        } else {
            graphContext += "I couldn't find information about the requested skills in the knowledge graph.\n";
        }
    }
    else if (intent === "get_work_info") {
        if (entities.length > 0) {
            for (const entity of entities) {
                if (entity.type === "Company" || entity.type === "Role") {
                    const cypherQuery = `
                        MATCH (p:Person {id: 'Siddharth Khanna'})-[r:WORKED_AT|HAS_ROLE]-(target)
                        WHERE toLower(target.name) CONTAINS toLower("${entity.name}") OR toLower(target.companyName) CONTAINS toLower("${entity.name}")
                        OPTIONAL MATCH (target)-[:APPLIES]->(s:Skill)
                        OPTIONAL MATCH (target)-[:USES]->(t:Technology)
                        RETURN target.name AS roleName, target.companyName AS company, target.duration AS duration, target.description AS roleDescription,
                                COLLECT(DISTINCT s.name) AS skills, COLLECT(DISTINCT t.name) AS technologies
                        LIMIT 1
                    `;
                    const result = await neo4jGraph.query(cypherQuery);
                    if (result.length > 0) {
                        const role = result[0];
                        graphContext += `Role: ${role.roleName} at ${role.company} (${role.duration})\n`;
                        graphContext += `Description: ${role.roleDescription}\n`;
                        if (role.skills && role.skills.length > 0) {
                            graphContext += `Skills Applied: ${role.skills.join(', ')}\n`;
                        }
                        if (role.technologies && role.technologies.length > 0) {
                            graphContext += `Technologies Used: ${role.technologies.join(', ')}\n`;
                        }
                        graphContext += "\n";
                    } else {
                        graphContext += `I couldn't find specific details for work experience related to "${entity.name}".\n`;
                    }
                }
            }
        } else {
            // General work experience query (list all)
            const cypherQuery = `
                MATCH (p:Person {id: 'Siddharth Khanna'})-[:WORKED_AT]->(c:Company)
                OPTIONAL MATCH (c)-[:HAS_ROLE]->(r:Role)
                RETURN c.name AS companyName, r.name AS roleName, r.duration AS duration, r.description AS description
                ORDER BY r.startDate DESC // Assuming you have startDate on Role nodes
            `;
            const result = await neo4jGraph.query(cypherQuery);
            if (result.length > 0) {
                graphContext += "Here is Sid's work experience:\n";
                result.forEach((entry: any) => {
                    graphContext += `- ${entry.roleName} at ${entry.companyName} (${entry.duration})\n`;
                    graphContext += `  Description: ${entry.description.substring(0, Math.min(entry.description.length, 150))}...\n\n`;
                });
            } else {
                graphContext += "I couldn't find work experience information in the knowledge graph.\n";
            }
        }
    }
    else if (intent === "get_personal_info") {
        // This covers education, background, interests, etc.
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

            // Safely assign properties, defaulting to empty arrays if undefined/null
            const education = personal.education || [];
            const interests = personal.interests || [];

            graphContext += `About Sid Khanna:\n`;
            if (personal.philosophy) graphContext += `Professional Philosophy: ${personal.philosophy}\n\n`;

            if (education.length > 0) { // Now safely checking length
                graphContext += `Education:\n`;
                education.forEach((edu: any) => {
                    graphContext += `- ${edu.degree} in ${edu.major} from ${edu.institution}\n`;
                });
                graphContext += "\n";
            }
            if (personal.background) graphContext += `Personal Background: ${personal.background}\n\n`;
            if (interests.length > 0) { // Now safely checking length
                graphContext += `Interests & Hobbies: ${interests.join(', ')}\n\n`;
            }
            if (personal.values) graphContext += `Personal Values & Approach: ${personal.values}\n\n`;
        } else {
            graphContext += "I couldn't find detailed personal information in the knowledge graph.\n";
        }
    }
    else if (intent === "general_query" || graphContext === "") {
        // Fallback if no specific intent or context is found
        graphContext += "I can provide information about Sid Khanna's projects, skills, work experience, education, and interests based on the knowledge graph.\n";
        graphContext += "Please ask a more specific question, e.g., 'What is ParSight?' or 'What are your programming skills?'";
    }


    // 3. Generate final answer using LLM (OpenRouter via fetch)
    const messages = [
      { role: 'system', content: getSystemPrompt() },
      { role: 'user', content: `--- Graph Context ---\n${graphContext}\n--- Relevant Text Snippets ---\n${textContext}\n--- User Question ---\n${question}` }
    ];

    // Direct fetch to OpenRouter for the final response, as ChatOpenAI is already initialized with configuration
    const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.OPENROUTER_API_KEY}`,
        'Content-Type': 'application/json',
        'HTTP-Referer': process.env.NEXT_PUBLIC_VERCEL_URL
          ? (process.env.NEXT_PUBLIC_VERCEL_URL.startsWith('http') ? process.env.NEXT_PUBLIC_VERCEL_URL : `https://${process.env.NEXT_PUBLIC_VERCEL_URL}`)
          : 'http://localhost:3000',
      },
      body: JSON.stringify({
        model: 'mistralai/mistral-7b-instruct',
        messages: messages,
        stream: true,
      }),
    });

    if (!response.ok) {
      const errorData = await response.json();
      console.error("OpenRouter API error:", errorData);
      throw new Error(`OpenRouter API error: ${response.status} - ${JSON.stringify(errorData)}`);
    }

    const stream = await OpenAIStream(response);
    return new StreamingTextResponse(stream);

  } catch (error) {
    console.error("Error in chat API:", error);
    return NextResponse.json({ error: "Internal Server Error", details: (error as Error).message }, { status: 500 });
  }
}