import React from 'react';
import {
  createRoot,
} from 'react-dom/client';
import {
  container,
} from './container';
import {
  SwaggerUi,
} from './pages/SwaggerUi';

const App: React.FC = () => {
  return (
    <div>
      <SwaggerUi />
    </div>
  );
};

const root = createRoot(container);
root.render(<App />);
