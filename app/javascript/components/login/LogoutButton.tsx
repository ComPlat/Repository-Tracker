import {
  Button,
} from 'antd';
import React from 'react';

export const LogoutButton = ({
  ...buttonProps
}) => {
  return (
    <Button
      {...buttonProps}
    >
      Logout
    </Button>
  );
};
