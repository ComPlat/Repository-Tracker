import {
  LockOutlined,
  UserOutlined,
} from '@ant-design/icons';
import {
  Form,
  Input,
  notification,
} from 'antd';
import type {
  NotificationPlacement,
} from 'antd/es/notification/interface';
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
  RevokeToken,
  Token,
} from '../helpers/Authentication';
import {
  getTokenFromLocalStorage,
  removeUserFromLocalStorage,
  storeUserInLocalStorage,
} from '../helpers/LocalStorageHelper';
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
  const [
    api,
    contextHolder,
  ] = notification.useNotification();

  const {
    user,
    setUser,
  } = useContext(UserContext);

  const Notification = (placement: NotificationPlacement, message: string, description: string) => {
    api.info({
      description,
      message,
      placement,
    });
  };

  const Login = async (email: string, password: string) => {
    const token = await Token(email, password);
    const userData: UserType = {
      email,
      token,
    };

    if (token.error === undefined) {
      storeUserInLocalStorage(userData);
      setUser(userData);
      Notification('bottomRight', 'Login successful', 'You have now access to the data.');
    } else {
      Notification('bottomRight', 'Login failed', 'The account data does not exist.');
    }
  };

  const Logout = async () => {
    const token = getTokenFromLocalStorage();

    if (user !== null) {
      await RevokeToken(token.access_token);
      removeUserFromLocalStorage('user');
      setUser(null);
      Notification('bottomRight', 'Logged out', 'You have successfully logged out.');
    }
  };

  return (
    <>
      {contextHolder}
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
          {user === null ? <LoginForm /> : <Title level={5}>{user.email}</Title>}
          <Form.Item>
            {user === null ? <LoginButton /> : <LogoutButton onClick={Logout} />}
          </Form.Item>
        </div>
      </Form>
    </>
  );
};
