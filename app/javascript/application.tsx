import React from 'react';
import ReactDOM from 'react-dom';
import SmartTable from './components/SmartTable';

const App = () => {
  return (
    <div className='p-8'>
      <div className='py-8'><h1>Repository-Tracker</h1></div>
      <SmartTable />
    </div>
  );
};

ReactDOM.render(<App />, document.querySelector('#spa'));
