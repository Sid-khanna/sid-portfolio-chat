'use client';

import { useMessage } from './MessageContext';
import type { Message } from './MessageContext';

export default function Chatbox() {
  const { messages } = useMessage() as { messages: Message[] };

  return (
    <div className="bg-black/40 rounded p-4 h-64 overflow-y-auto mb-4 space-y-3">
      {messages.map((msg, i) => (
        <div
          key={i}
          className={`flex ${msg.role === 'user' ? 'justify-end' : 'justify-start'}`}
        >
          <div
            className={`max-w-xs px-4 py-2 rounded-lg text-sm ${
              msg.role === 'user'
                ? 'bg-orange-600 text-white rounded-br-none'
                : 'bg-gray-700 text-white rounded-bl-none'
            }`}
          >
            {msg.content}
          </div>
        </div>
      ))}
    </div>
  );
}
