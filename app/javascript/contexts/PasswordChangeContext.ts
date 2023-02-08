import type {
  Dispatch,
  SetStateAction,
} from 'react';
import {
  createContext,
} from 'react';

type ChangeStatus = 'error' | 'success' | null;

export type PasswordChangeContextType = {
  passwordChange: ChangeStatus,
  setPasswordChange: Dispatch<SetStateAction<ChangeStatus>>,
};

export const PasswordChangeContext = createContext<PasswordChangeContextType>({
  passwordChange: null,
  setPasswordChange: () => {},
});
