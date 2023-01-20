import type {
  Dispatch,
  SetStateAction,
} from 'react';
import {
  createContext,
} from 'react';

export type RegisterContextType = {
  register: boolean,
  setRegister: Dispatch<SetStateAction<boolean>>,
};

export const RegisterContext = createContext<RegisterContextType>({
  register: false,
  setRegister: () => {},
});
