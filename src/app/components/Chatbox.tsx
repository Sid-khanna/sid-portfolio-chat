'use client';

import { useMessage } from './MessageContext';
import type { Message } from './MessageContext';

export default function Chatbox() {
  const { messages } = useMessage();

  return (
    <div className="bg-black/40 rounded p-4 h-64 overflow-y-auto mb-4 space-y-3">
      {messages.map((msg, i) => {
        const isUser = msg.role === 'user';
        return (
          <div
            key={i}
            className={`max-w-[80%] px-4 py-2 rounded-lg ${
              isUser
                ? 'bg-orange-500 text-white self-end ml-auto'
                : 'bg-gray-800 text-white self-start mr-auto'
            }`}
            {...(!isUser && msg.content
              ? { dangerouslySetInnerHTML: { __html: msg.content } }
              : {})}
          >
            {isUser && msg.content}
          </div>
        );
      })}
    </div>
  );
}
