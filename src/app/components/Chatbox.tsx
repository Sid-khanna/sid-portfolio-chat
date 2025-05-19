import { useMessage } from './MessageContext';

export default function Chatbox() {
  const { messages } = useMessage(); // no need to cast here if your context is typed

  return (
    <div className="bg-black/40 rounded p-4 h-64 overflow-y-auto mb-4 space-y-3">
      {messages.map((msg, i) => (
        <p key={i}>
          <strong>{msg.role === 'user' ? 'you' : 'sid'}:</strong> {msg.content}
        </p>
      ))}
    </div>
  );
}
