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
  Login,
} from './components/Login';
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
            {register ? <Registration /> : <SmartTable />}
          </Row>
        </Padding>
      </RegisterContext.Provider>
    </UserContext.Provider>
  );
};

const root = createRoot(container);
root.render(<App />);
