import React from 'react';
import {
  createRoot,
} from 'react-dom/client';
import SwaggerUIReact from 'swagger-ui-react';
import {
  clientId,
  containerSwagger,
} from './swagger/containerSwagger';

const App: React.FC = () => {
  return (
    <div>
      <h2
        className='swagger-ui h2'
        style={{
          boxSizing: 'border-box',
          margin: '0 auto',
          maxWidth: '1460px',
          padding: '0 20px',
          width: '100%',
        }}
      >Client ID: {clientId}</h2>
      <SwaggerUIReact deepLinking persistAuthorization url='/api/swagger_doc.json' />
    </div>
  );
};

const root = createRoot(containerSwagger);
root.render(<App />);
