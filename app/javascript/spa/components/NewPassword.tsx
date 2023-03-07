import Title from 'antd/es/typography/Title';
import React, {
  useContext,
} from 'react';
import {
  PasswordChangeContext,
} from '../contexts/PasswordChangeContext';
import {
  NewPasswordErrorResult,
} from './new-password/NewPasswordErrorResult';
import {
  NewPasswordForm,
} from './new-password/NewPasswordForm';
import {
  NewPasswordSuccessfulResult,
} from './new-password/NewPasswordSuccessfulResult';

export const NewPassword: React.FC = () => {
  const {
    passwordChange,
  } = useContext(PasswordChangeContext);

  const defaultComponent = () => {
    return (
      <div>
        <Title
          level={3} style={{
            alignItems: 'center',
            display: 'flex',
            justifyContent: 'center',
            marginBottom: '2em',
          }}
        >New password
        </Title>
        <NewPasswordForm />
      </div>
    );
  };

  const component = () => {
    switch (passwordChange) {
      case 'success': return <div><NewPasswordSuccessfulResult /></div>;
      case 'error': return <div><NewPasswordErrorResult /></div>;
      default: return defaultComponent();
    }
  };

  return (
    <div>{component()}</div>
  );
};
