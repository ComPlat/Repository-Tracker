import {
  clientId,
} from '../container';
import {
  storeTokenInLocalStorage,
} from './LocalStorageHelper';

export const Token = async (email: string, password: string) => {
  const response = await fetch('/oauth/token', {
    body: JSON.stringify({
      client_id: clientId,
      email,
      grant_type: 'password',
      password,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
    method: 'POST',
  });
  const token = await response.json();
  storeTokenInLocalStorage(token);

  return token;
};

export const RevokeToken = async (token: string) => {
  const response = await fetch('/oauth/revoke', {
    body: JSON.stringify({
      client_id: clientId,
      token,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
    method: 'POST',
  });

  return await response.json();
};
