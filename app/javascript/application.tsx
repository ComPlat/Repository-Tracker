import {
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
  LoginScreen,
} from './components/LoginScreen';
import {
  RegistrationScreen,
} from './components/RegistrationScreen';
import SmartTable from './components/SmartTable';
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

const App = () => {
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
        <div style={{
          padding: '1rem',
        }}
        >
          <div style={{
            display: 'flex',
            justifyContent: 'space-between',
          }}
          >
            <Title>Repository-Tracker</Title>
            <LoginScreen />
          </div>
          <div style={{
            backgroundColor: 'white',
            padding: '2rem',
          }}
          >
            {register ? <RegistrationScreen /> : <SmartTable />}
          </div>
        </div>
      </RegisterContext.Provider>
    </UserContext.Provider>
  );
};

const root = createRoot(container);
root.render(<App />);
