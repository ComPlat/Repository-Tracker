import React from 'react';
import {
  createRoot,
} from 'react-dom/client';
import {
  Spa,
} from './spa/Spa';
import {
  containerSpa,
} from './spa/containerSpa';

const App: React.FC = () => {
  return <Spa />;
};

const root = createRoot(containerSpa);
root.render(<App />);
