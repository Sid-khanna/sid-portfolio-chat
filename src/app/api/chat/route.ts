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

// Helper to look for project alias in old projectDetails fallback
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

export async function POST(req: Request) {
  const { message } = await req.json();

  const systemMessage = { role: 'system', content: getSystemPrompt() };
  const userMessage = { role: 'user', content: message };

  let projectContext = null;

  // ✅ Try fuzzy match using Neo4j fulltext index
  const session = driver.session();
  try {
    const result = await session.run(
      `
      CALL db.index.fulltext.queryNodes('projectIndex', $msg)
      YIELD node, score
      RETURN node.id AS id, node.content AS content
      ORDER BY score DESC
      LIMIT 1
      `,
      { msg: message }
    );

    const record = result.records[0];
    if (record) {
      const id = record.get('id');
      const content = record.get('content');
      projectContext = {
        role: 'system',
        content: `Here is official background context for the user's query on "${id}":\n\n${content}`,
      };
    }
  } catch (err) {
    console.error('Neo4j fuzzy match failed:', err);
  } finally {
    await session.close();
  }

  // ✅ Fallback to legacy projectDetails if no match found
  if (!projectContext) {
    const fallback = getProjectDetailFromMessage(message);
    if (fallback) {
      projectContext = {
        role: 'system',
        content: `Here is background context for the user's query:\n\n${fallback}`,
      };
    }
  }

  const messages = projectContext
    ? [systemMessage, projectContext, userMessage]
    : [systemMessage, userMessage];

  const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.OPENROUTER_API_KEY}`,
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://localhost:3000',
    },
    body: JSON.stringify({
      model: 'mistralai/mistral-7b-instruct',
      messages: messages,
      stream: true,
    }),
  });

    const stream = await OpenAIStream(response);
    return new StreamingTextResponse(stream);

  } catch (error) {
    console.error("Error in chat API:", error);
    return NextResponse.json({ error: "Internal Server Error", details: (error as Error).message }, { status: 500 });
  }
}