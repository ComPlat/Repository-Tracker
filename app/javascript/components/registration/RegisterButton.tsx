import {
  Button,
} from 'antd';
import React from 'react';

export const RegisterButton = ({
  ...buttonProps
}) => {
  return (
    <Button
      type='default'
      {...buttonProps}
    >
      Register
    </Button>
  );
};
