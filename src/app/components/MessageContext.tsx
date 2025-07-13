'use client';

import { createContext, useContext, useState, ReactNode, useMemo } from 'react';

// 1. Define the shape of a single message
export interface Message {
  role: 'user' | 'assistant';
  content: string;
}

// 2. Define the context value type
interface MessageContextType {
  messages: Message[];
  setMessages: React.Dispatch<React.SetStateAction<Message[]>>;
  filteredMessagesForAPI: Message[];
}

// 3. Create context with proper type
const MessageContext = createContext<MessageContextType | undefined>(undefined);

// 4. Provider with children typed
export const MessageProvider = ({ children }: { children: ReactNode }) => {
  const [messages, setMessages] = useState<Message[]>([
    {
      role: 'assistant',
      content: "hi, i'm sid — feel free to ask about my background, projects, or portfolio.",
    },
  ]);

  // 5. Filter out the initial preset assistant message for API usage
  const filteredMessagesForAPI = useMemo(() => {
    return messages.slice(1); // skip the first assistant message
  }, [messages]);

  return (
    <MessageContext.Provider value={{ messages, setMessages, filteredMessagesForAPI }}>
      {children}
    </MessageContext.Provider>
  );
};

// 6. Hook with error if used outside provider
export const useMessage = () => {
  const context = useContext(MessageContext);
  if (!context) throw new Error('useMessage must be used within a MessageProvider');
  return context;
};
