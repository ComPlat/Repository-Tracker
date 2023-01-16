import React from 'react';
import {
  SignUpForm,
} from './registration-screen/SignUpForm';

export const RegistrationScreen = () => {
  return (
    <div style={{
      alignItems: 'center',
      display: 'flex',
      justifyContent: 'center',
    }}
    >
      <SignUpForm />
    </div>
  );
};
