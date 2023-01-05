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
  UserContext,
} from './contexts/UserContext';
import assertNonNullish from './helpers/assertNonNullish';

const {
  Title,
} = Typography;

const App = () => {
  const [
    user,
    setUser,
  ] = useState(
    JSON.parse(localStorage.getItem('user') as string),
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
    localStorage.setItem('user', JSON.stringify(user));
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

const container = document.querySelector('#spa');
assertNonNullish(container, 'Unable to find DOM element #spa');

const root = createRoot(container);
root.render(<App />);
