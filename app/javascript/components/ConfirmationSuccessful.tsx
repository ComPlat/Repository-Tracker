import {
  Button,
  Result,
} from 'antd';
import React from 'react';
import {
  useNavigate,
} from 'react-router-dom';

export const ConfirmationSuccessful: React.FC = () => {
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
      status='success'
      subTitle='You can now login into the application.'
      title='E-Mail confirmation successful!'
    />
  );
};
