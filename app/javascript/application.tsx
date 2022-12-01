import React from 'react';
import ReactDOM from 'react-dom';
import SmartTable from './components/SmartTable';

const App = () => {
  return (
    <div className='p-8'>
      <SmartTable />
    </div>
  );
};

ReactDOM.render(<App />, document.querySelector('#spa'));
