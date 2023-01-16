import {
  Form,
  notification,
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
} from '../helpers/Authentication';
import {
  getTokenFromLocalStorage,
  storeUserInLocalStorage,
} from '../helpers/LocalStorageHelper';
import {
  LoginButton,
} from './login-screen/LoginButton';
import {
  LoginForm,
} from './login-screen/LoginForm';
import {
  LogoutButton,
} from './login-screen/LogoutButton';
import {
  RegisterButton,
} from './registration-screen/RegisterButton';

export const LoginScreen = () => {
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

  const Notification = useCallback((placement: NotificationPlacement, message: string, description: string) => {
    api.info({
      description,
      message,
      placement,
    });
  }, [
    api,
  ]);

  const Logout = useCallback(async () => {
    const token = getTokenFromLocalStorage();

    if (user !== null) {
      await RevokeToken(token.access_token);
      localStorage.clear();
      setUser(null);
      Notification('bottomRight', 'Logged out', 'You have successfully logged out.');
    }
  }, [
    Notification,
    setUser,
    user,
  ]);

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
          {user === null ? <RegisterButton onClick={() => {
            setRegister(true);
          }}
          /> : null}
        </div>
      </Form>
    </>
  );
};
