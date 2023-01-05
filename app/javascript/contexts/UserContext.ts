import {
  createContext,
} from 'react';

export type UserContextType = {
  email: string,
  token: {
    access_token: string,
    created_at: number,
    expires_in: number,
    refresh_token: string,
    token_type: string,
  },
};

export const UserContext = createContext<UserContextType | null>(null);
