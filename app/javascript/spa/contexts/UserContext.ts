import type {
  Dispatch,
  SetStateAction,
} from 'react';
import {
  createContext,
} from 'react';

export type TokenType = {
  access_token: string,
  created_at: number,
  expires_in: number,
  refresh_token: string,
  token_type: string,
};

export type UserType = {
  email: string | null,
  token: {
    access_token: string,
    created_at: number,
    expires_in: number,
    refresh_token: string,
    token_type: string,
  } | null,
};

export type UserContextType = {
  setUser: Dispatch<SetStateAction<UserType | null>>,
  user: UserType,
};

const defaultUser: UserType = {
  email: null,
  token: null,
};

export const UserContext = createContext<UserContextType>({
  setUser: () => {},
  user: defaultUser,
});
