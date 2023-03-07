import {
  Button,
  Result,
} from 'antd';
import React from 'react';
import {
  useNavigate,
} from 'react-router-dom';

export const NotFound: React.FC = () => {
  const navigate = useNavigate();

  const onClick = () => {
    navigate('/');
  };

  return <Result
    extra={
      <Button onClick={onClick} type='primary'>
        Back Home
      </Button>
    }
    status='404'
    subTitle="Sorry, the page you were looking for doesn't exist.
        You may have mistyped the address or the page may have moved."
    title='404'
  />;
};

