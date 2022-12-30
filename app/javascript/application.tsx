import {
  Space,
  Typography,
} from 'antd';
import React from 'react';
import {
  createRoot,
} from 'react-dom/client';
import SmartTable from './components/SmartTable';
import assertNonNullish from './helpers/assertNonNullish';

const {
  Title,
} = Typography;

const App = () => {
  return (
    <Space size='large'>
      <div style={{
        padding: '24px',
      }}
      >
        <Title>Repository-Tracker</Title>
        <SmartTable />
      </div>
    </Space>
  );
};

const container = document.querySelector('#spa');
assertNonNullish(container, 'Unable to find DOM element #spa');

const root = createRoot(container);
root.render(<App />);
