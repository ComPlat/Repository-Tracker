import {
  Button,
  Result,
} from 'antd';
import React from 'react';
import {
  useNavigate,
} from 'react-router-dom';

export const ConfirmationError: React.FC = () => {
  const navigate = useNavigate();

  const onClick = () => {
    navigate('/');
  };

  return (
    <Result
      extra={[
        <Button key='button-navigate-to-root' onClick={onClick} type='primary'>
          Back Home
        </Button>,
      ]}
      status='error'
      subTitle='Please check your confirmation link and try again.'
      title='E-Mail confirmation failed!'
    />
  );
};
