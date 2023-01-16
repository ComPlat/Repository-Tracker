import {
  LockOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Form,
  Input,
} from 'antd';
import React from 'react';

export const LoginForm = () => {
  return (
    <div style={{
      display: 'flex',
      gap: '1rem',
      justifyContent: 'space-between',
    }}
    >
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
    </div>
  );
};
