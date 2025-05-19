import { OpenAIStream } from '@/lib/OpenAIStream';
import { StreamingTextResponse } from '@/lib/StreamingTextResponse';
import getSystemPrompt from './prompt';

export const runtime = 'edge';

export async function POST(req: Request) {
  const { message } = await req.json();

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
