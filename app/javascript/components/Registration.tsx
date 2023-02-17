import {
  Space,
} from 'antd';
import React from 'react';
import {
  RegisterForm,
} from './registration/RegisterForm';

export const Registration: React.FC = () => {
  return (
    <Space>
      <RegisterForm />
    </Space>
  );
};
