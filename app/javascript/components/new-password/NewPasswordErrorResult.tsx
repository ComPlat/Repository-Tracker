import {
  Button,
  Result,
} from 'antd';
import React from 'react';
import {
  useNavigate,
} from 'react-router-dom';

export const NewPasswordErrorResult: React.FC = () => {
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
      subTitle='Please try again.'
      title='Password change failed'
    />
  );
};
