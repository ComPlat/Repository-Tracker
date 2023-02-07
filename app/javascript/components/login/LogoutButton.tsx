import {
  Button,
} from 'antd';
import React from 'react';

export const LogoutButton: React.FC = ({
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
