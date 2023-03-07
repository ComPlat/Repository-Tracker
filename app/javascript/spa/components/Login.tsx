import {
  Form,
  notification,
  Space,
} from 'antd';
import type {
  NotificationPlacement,
} from 'antd/es/notification/interface';
import Title from 'antd/es/typography/Title';
import React, {
  useCallback,
  useContext,
} from 'react';
import {
  NavLink,
} from 'react-router-dom';
import {
  RegisterContext,
} from '../contexts/RegisterContext';
import type {
  UserType,
} from '../contexts/UserContext';
import {
  UserContext,
} from '../contexts/UserContext';
import {
  RevokeToken,
  Token,
} from '../helpers/AuthenticationHelper';
import {
  getTokenFromLocalStorage,
  storeUserInLocalStorage,
} from '../helpers/LocalStorageHelper';
import {
  LoginButton,
} from './login/LoginButton';
import {
  LoginForm,
} from './login/LoginForm';
import {
  LogoutButton,
} from './login/LogoutButton';
import {
  RegisterButton,
} from './registration/RegisterButton';

export const Login: React.FC = () => {
  const [
    api,
    contextHolder,
  ] = notification.useNotification();

  const {
    user,
    setUser,
  } = useContext(UserContext);

  const {
    setRegister,
  } = useContext(RegisterContext);

  type NotificationProps = {
    children: React.ReactNode,
  };

  const Notification = useCallback((placement: NotificationPlacement, message: string, {
    children,
  }: NotificationProps) => {
    api.info({
      description: children,
      message,
      placement,
    });
  }, [
    api,
  ]);

  const LogoutFromSystem = useCallback(async () => {
    const token = getTokenFromLocalStorage();

    if (user !== null) {
      await RevokeToken(token.access_token);
      localStorage.clear();
      setUser(null);
      Notification('bottomRight',
        'Logged out',
        {
          children: <div>You have successfully logged out.</div>,
        });
    }
  }, [
    Notification,
    setUser,
    user,
  ]);

  const LoginIntoSystem = async (email: string, password: string) => {
    const token = await Token(email, password);
    const userData: UserType = {
      email,
      token,
    };

    if (token.error === undefined) {
      storeUserInLocalStorage(userData);
      setUser(userData);
      Notification('bottomRight',
        'Login successful',
        {
          children: <div>You have now access to the data.</div>,
        });
    } else {
      Notification('bottomRight',
        'Login failed',
        {
          children:
  <div>
    The account data does not exist.
    <p>Forgot your password? <NavLink to='/spa/password_reset'>Click here</NavLink></p>
  </div>,
        });
    }
  };

  return (
    <Space>
      {contextHolder}
      <Form
        className='login-form'
        initialValues={{
          remember: true,
        }}
        name='normal_login'
        onFinish={async (value) => {
          await LoginIntoSystem(value.email, value.password);
        }}
      >
        {(() => {
          if (user === null) {
            return (
              <Space.Compact>
                <LoginForm />
                <LoginButton />
                <RegisterButton onClick={() => {
                  setRegister(true);
                }}
                />
              </Space.Compact>
            );
          } else {
            return (
              <Space size='large'>
                <Title level={5}>{user.email}</Title>
                <LogoutButton onClick={LogoutFromSystem} />
              </Space>
            );
          }
        })()}
      </Form>
    </Space>
  );
};
