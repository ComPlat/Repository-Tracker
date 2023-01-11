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
import SmartTable from './components/SmartTable';
import {
  container,
} from './container';
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

  const providerValue = useMemo(() => {
    return {
      setUser,
      user,
    };
  }, [
    user,
    setUser,
  ]);

  useEffect(() => {
    storeUserInLocalStorage(user);
  }, [
    user,
  ]);

  return (
    <UserContext.Provider value={providerValue}>
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
          <SmartTable />
        </div>
      </div>
    </UserContext.Provider>
  );
};

const root = createRoot(container);
root.render(<App />);
