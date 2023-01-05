import {
  LockOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Form,
  Input,
} from 'antd';
import Title from 'antd/es/typography/Title';
import React, {
  useContext,
} from 'react';
import type {
  UserType,
} from '../contexts/UserContext';
import {
  UserContext,
} from '../contexts/UserContext';
import {
  Token,
} from '../helpers/Authentication';
import {
  LoginButton,
} from './login-screen/LoginButton';
import {
  LogoutButton,
} from './login-screen/LogoutButton';

const LoginForm = () => {
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

export const LoginScreen = () => {
  const {
    user,
    setUser,
  } = useContext(UserContext);

  const Login = async (email: string, password: string) => {
    const token = await Token(email, password);
    const userData: UserType = {
      email,
      token,
    };
    localStorage.setItem('user', JSON.stringify(userData));
    setUser(userData);
  };

  const Logout = () => {
    if (user !== null) {
      localStorage.removeItem('user');
      setUser(null);
    }
  };

  return (
    <Form
      className='login-form'
      initialValues={{
        remember: true,
      }}
      name='normal_login'
      onFinish={async (value) => {
        await Login(value.email, value.password);
      }}
    >
      <div style={{
        display: 'flex',
        gap: '1rem',
        justifyContent: 'space-between',
      }}
      >
        {user === null ? <LoginForm /> :
        <Title level={5}>{JSON.parse(localStorage.getItem('user') as string).email}</Title>}
        <Form.Item>
          {user === null ? <LoginButton /> : <LogoutButton onClick={Logout} />}
        </Form.Item>
      </div>
    </Form>
  );
};
