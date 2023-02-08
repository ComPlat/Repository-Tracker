import Title from 'antd/es/typography/Title';
import React, {
  useContext,
} from 'react';
import {
  PasswordChangeContext,
} from '../contexts/PasswordChangeContext';
import {
  NewPasswordForm,
} from './new-password/NewPasswordForm';
import {
  PasswordChangeErrorResult,
} from './new-password/PasswordChangeErrorResult';
import {
  PasswordChangeSuccessfulResult,
} from './new-password/PasswordChangeSuccessfulResult';

export const NewPassword: React.FC = () => {
  const {
    passwordChange,
  } = useContext(PasswordChangeContext);

  return (
    <div>
      {(
        () => {
          if (passwordChange === 'success') {
            return <div><PasswordChangeSuccessfulResult /></div>;
          } else if (passwordChange === 'error') {
            return <div><PasswordChangeErrorResult /></div>;
          } else {
            return <div>
              <Title
                level={3} style={{
                  alignItems: 'center',
                  display: 'flex',
                  justifyContent: 'center',
                  marginBottom: '2em',
                }}
              >New password</Title>
              <NewPasswordForm />
            </div>;
          }
        }
      )()}
    </div>
  );
};
