import {
  createContext,
} from 'react';

export type UserType = {
  email: string,
  token: {
    access_token: string,
    created_at: number,
    expires_in: number,
    refresh_token: string,
    token_type: string,
  },
};

export const UserContext = createContext<UserType | null>(null);
