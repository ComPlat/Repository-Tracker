import {
  Button,
  Result,
} from 'antd';
import {
  capitalize,
} from 'lodash';
import React from 'react';
import {
  useNavigate,
  useSearchParams,
} from 'react-router-dom';

export const ConfirmationError: React.FC = () => {
  const navigate = useNavigate();

  const onClick = () => {
    navigate('/');
  };

  const [
    searchParameters,
  ] = useSearchParams();

  const errorType = () => {
    return searchParameters.toString().split('=');
  };

  const errorMessage = () => {
    return `${capitalize(errorType()[0]).replace('_', ' ')}: ${errorType()[1]}`;
  };

  return (
    <Result
      extra={[
        <Button key='button-navigate-to-root' onClick={onClick} type='primary'>
          Back Home
        </Button>,
      ]}
      status='error'
      subTitle={`${errorMessage()}`}
      title='E-Mail confirmation failed!'
    />
  );
};
