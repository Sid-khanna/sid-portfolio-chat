'use client';

import { useMessage } from './MessageContext';


export default function Chatbox() {
  const { messages } = useMessage();

  return (
    <div className="bg-black/40 rounded p-4 h-64 overflow-y-auto mb-4 space-y-3">
      {messages.map((msg, i) => (
        <div
          key={i}
          className={`p-3 rounded-xl max-w-[85%] ${
            msg.role === 'user'
              ? 'bg-gray-700 self-end text-right ml-auto'
              : 'bg-indigo-800 self-start text-left mr-auto'
          }`}
        >
          <p className="text-sm text-white">
            <strong>{msg.role === 'user' ? 'you' : 'sid'}</strong>:&nbsp;
            <span dangerouslySetInnerHTML={{ __html: msg.content }} />
          </p>
        </div>
      ))}
    </div>
  );
}
