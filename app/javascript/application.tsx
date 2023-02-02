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
  createRoot,
} from 'react-dom/client';
import {
  BrowserRouter,
  Route,
  Routes,
} from 'react-router-dom';
import {
  ConfirmationError,
} from './components/ConfirmationError';
import {
  ConfirmationSuccessful,
} from './components/ConfirmationSuccessful';
import {
  Login,
} from './components/Login';
import {
  NotFound,
} from './components/NotFound';
import {
  Registration,
} from './components/Registration';
import SmartTable from './components/SmartTable';
import {
  Header,
} from './components/custom-styling/Header';
import {
  Padding,
} from './components/custom-styling/Padding';
import {
  container,
} from './container';
import {
  RegisterContext,
} from './contexts/RegisterContext';
import {
  UserContext,
} from './contexts/UserContext';
import {
  getUserFromLocalStorage,
  storeUserInLocalStorage,
} from './helpers/LocalStorageHelper';

const {
  Title,
} = Typography;

const App: React.FC = () => {
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

  useEffect(() => {
    storeUserInLocalStorage(user);
  }, [
    user,
  ]);

  return (
    <BrowserRouter>
      <UserContext.Provider value={userProviderValue}>
        <RegisterContext.Provider value={registerProviderValue}>
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
                <Route element={<ConfirmationSuccessful />} path='/confirmation_successful' />
                <Route element={<ConfirmationError />} path='/confirmation_error' />
                <Route element={<NotFound />} path='/*' />
              </Routes>
            </Row>
          </Padding>
        </RegisterContext.Provider>
      </UserContext.Provider>
    </BrowserRouter>
  );
};

const root = createRoot(container);
root.render(<App />);
