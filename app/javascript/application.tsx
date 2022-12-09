import {
  Typography,
} from 'antd';
import React from 'react';
import {
  createRoot,
} from 'react-dom/client';
import assertNonNullish from '../helpers/assertNonNullish';
import SmartTable from './components/SmartTable';

const {
  Title,
} = Typography;

const App = () => {
  return (
    <div className='p-8'>
      <Title>Repository-Tracker</Title>
      <SmartTable />
    </div>
  );
};

const container = document.querySelector('#spa');
assertNonNullish(container, 'Unable to find DOM element #spa');

const root = createRoot(container);
root.render(<App />);
