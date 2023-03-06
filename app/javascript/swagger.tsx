import React from 'react';
import {
  createRoot,
} from 'react-dom/client';
import SwaggerUIReact from 'swagger-ui-react';
import {
  containerSwagger,
} from './swagger/containerSwagger';

const App: React.FC = () => {
  return <SwaggerUIReact deepLinking persistAuthorization url='/api/swagger_doc.json' />;
};

const root = createRoot(containerSwagger);
root.render(<App />);
