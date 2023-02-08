import {
  Button,
  Result,
} from 'antd';
import React from 'react';
import {
  useNavigate,
} from 'react-router-dom';

export const PasswordChangeErrorResult = () => {
  const navigate = useNavigate();

  return (
    <Result
      extra={[
        <Button
          key='button-navigate-to-root' onClick={() => {
            navigate('/');
          }} type='primary'
        >
          Back Home
        </Button>,
      ]}
      status='error'
      subTitle='Please try again.'
      title='Password change failed'
    />
  );
};
