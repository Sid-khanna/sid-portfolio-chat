import { OpenAIStream } from '@/lib/OpenAIStream';
import { StreamingTextResponse } from '@/lib/StreamingTextResponse';
import getSystemPrompt from './prompt';

// ✅ NEW: Import projectDetails
import { projectDetails } from '../../projectDetails';

// ✅ NEW: Helper function to check for project query
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

export const runtime = 'edge';

export async function POST(req: Request) {
  const { message } = await req.json();

  // ✅ NEW: Check for project match before calling LLM
  const matchedProject = getProjectDetailFromMessage(message);
  if (matchedProject) {
    return new Response(JSON.stringify({
      role: 'assistant',
      content: matchedProject,
    }));
  }

  // LLM fallback if not a project match
  const response = await fetch('https://openrouter.ai/api/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.OPENROUTER_API_KEY}`,
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://localhost:3000', // change this on deploy
    },
    body: JSON.stringify({
      model: 'mistralai/mistral-7b-instruct',
      messages: [
        { role: 'system', content: getSystemPrompt() },
        { role: 'user', content: message },
      ],
      stream: true,
    }),
  });

  const stream = await OpenAIStream(response);
  return new StreamingTextResponse(stream);
}
