import {
  Col,
  Row,
  Typography,
} from 'antd';
import React, {
  useEffect,
  useMemo,
  useState,
} from 'react';
import {
  BrowserRouter,
  Route,
  Routes,
} from 'react-router-dom';
import {
  Login,
} from '../components/Login';
import {
  NewPassword,
} from '../components/NewPassword';
import {
  PasswordReset,
} from '../components/PasswordReset';
import {
  Registration,
} from '../components/Registration';
import SmartTable from '../components/SmartTable';
import {
  Header,
} from '../components/custom-styling/Header';
import {
  Padding,
} from '../components/custom-styling/Padding';
import {
  NotFound,
} from '../components/error-handling/NotFound';
import {
  ConfirmationError,
} from '../components/registration/ConfirmationError';
import {
  ConfirmationSuccessful,
} from '../components/registration/ConfirmationSuccessful';
import {
  PasswordChangeContext,
} from '../contexts/PasswordChangeContext';
import {
  RegisterContext,
} from '../contexts/RegisterContext';
import {
  UserContext,
} from '../contexts/UserContext';
import {
  getUserFromLocalStorage,
  storeUserInLocalStorage,
} from '../helpers/LocalStorageHelper';

const {
  Title,
} = Typography;

export const Spa: React.FC = () => {
  const [
    user,
    setUser,
  ] = useState(
    getUserFromLocalStorage(),
  );

  const [
    register,
    setRegister,
  ] = useState(false);

  const [
    passwordChange,
    setPasswordChange,
  ] = useState(null);

  const userProviderValue = useMemo(() => {
    return {
      setUser,
      user,
    };
  }, [
    user,
    setUser,
  ]);

  const registerProviderValue = useMemo(() => {
    return {
      register,
      setRegister,
    };
  }, [
    register,
  ]);

  const passwordChangeProviderValue = useMemo(() => {
    return {
      passwordChange,
      setPasswordChange,
    };
  }, [
    passwordChange,
  ]);

  useEffect(() => {
    storeUserInLocalStorage(user);
  }, [
    user,
  ]);

  return (
    <BrowserRouter>
      <UserContext.Provider value={userProviderValue}>
        <RegisterContext.Provider value={registerProviderValue}>
          <PasswordChangeContext.Provider value={passwordChangeProviderValue}>
            <Padding>
              <Header>
                <Row justify='space-between'>
                  <Col><Title>Repository-Tracker</Title></Col>
                  <Col><Login /></Col>
                </Row>
              </Header>
              <Row justify='center'>
                <Routes>
                  <Route element={register ? <Registration /> : <SmartTable />} path='/' />
                  <Route element={<ConfirmationSuccessful />} path='/spa/confirmation_successful' />
                  <Route element={<ConfirmationError />} path='/spa/confirmation_error' />
                  <Route element={<PasswordReset />} path='/spa/password_reset' />
                  <Route element={<NewPassword />} path='/spa/new_password/*' />
                  <Route element={<NotFound />} path='/spa/*' />
                </Routes>
              </Row>
            </Padding>
          </PasswordChangeContext.Provider>
        </RegisterContext.Provider>
      </UserContext.Provider>
    </BrowserRouter>
  );
};
