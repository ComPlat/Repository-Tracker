import Title from 'antd/es/typography/Title';
import React from 'react';
import {
  PasswordResetForm,
} from './password-reset/PasswordResetForm';

export const PasswordReset: React.FC = () => {
  return (
    <div>
      <Title
        level={3} style={{
          alignItems: 'center',
          display: 'flex',
          justifyContent: 'center',
        }}
      >Password reset</Title>
      <PasswordResetForm />
    </div>
  );
};
