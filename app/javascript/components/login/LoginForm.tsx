import {
  LockOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Form,
  Input,
  Space,
} from 'antd';
import React from 'react';

export const LoginForm: React.FC = () => {
  return (
    <Space.Compact>
      <Form.Item
        name='email'
        rules={[
          {
            message: 'Please input your E-Mail address!',
            required: true,
          },
        ]}
      >
        <Input
          placeholder='E-Mail address'
          prefix={<UserOutlined className='site-form-item-icon' />}
        />
      </Form.Item>
      <Form.Item
        name='password'
        rules={[
          {
            message: 'Please input your Password!',
            required: true,
          },
        ]}
      >
        <Input
          placeholder='Password'
          prefix={<LockOutlined className='site-form-item-icon' />}
          type='password'
        />
      </Form.Item>
    </Space.Compact>
  );
};
