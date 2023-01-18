import React from 'react';
import {
  RegisterForm,
} from './registration/RegisterForm';

export const Registration = () => {
  return (
    <div style={{
      alignItems: 'center',
      display: 'flex',
      justifyContent: 'center',
    }}
    >
      <RegisterForm />
    </div>
  );
};
