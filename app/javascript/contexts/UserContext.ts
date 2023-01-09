import type {
  Dispatch,
  SetStateAction,
} from 'react';
import {
  createContext,
} from 'react';

export type UserType = {
  email: string | null,
  token: {
    access_token: string | null,
    created_at: number | null,
    expires_in: number | null,
    refresh_token: string | null,
    token_type: string | null,
  },
};

export type UserContextType = {
  setUser: Dispatch<SetStateAction<UserType | null>>,
  user: UserType | null,
};

const defaultUser: UserType = {
  email: null,
  token: {
    access_token: null,
    created_at: null,
    expires_in: null,
    refresh_token: null,
    token_type: null,
  },
};

export const UserContext = createContext<UserContextType>({
  setUser: () => {},
  user: defaultUser,
});
