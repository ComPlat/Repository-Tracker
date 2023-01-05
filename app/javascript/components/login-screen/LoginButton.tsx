import {
  Button,
} from 'antd';
import React from 'react';

export const LoginButton = ({
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
