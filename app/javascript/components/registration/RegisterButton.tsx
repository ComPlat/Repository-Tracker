import {
  Button,
} from 'antd';
import React from 'react';

export const RegisterButton: React.FC = ({
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
