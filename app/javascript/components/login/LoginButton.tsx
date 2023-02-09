import {
  Button,
} from 'antd';
import React from 'react';

export const LoginButton: React.FC = ({
  ...buttonProps
}) => {
  return (
    <Button
      className='login-form-button' htmlType='submit'
      type='primary'
      {...buttonProps}
    >
      Login
    </Button>
  );
};
