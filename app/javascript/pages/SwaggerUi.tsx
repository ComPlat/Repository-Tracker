import React from 'react';
import {
  BrowserRouter,
  Route,
  Routes,
} from 'react-router-dom';
import SwaggerUIReact from 'swagger-ui-react';

export const SwaggerUi = (): JSX.Element => {
  const jsx = <SwaggerUIReact deepLinking persistAuthorization url='/api/swagger_doc.json' />;

  return (
    <BrowserRouter>
      <Routes>
        <Route element={jsx} path='/swagger' />
      </Routes>
    </BrowserRouter>
  );
};
