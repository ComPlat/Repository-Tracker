import {
  Typography,
} from 'antd';
import React from 'react';
import ReactDOM from 'react-dom';
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

ReactDOM.render(<App />, document.querySelector('#spa'));
