import {
  clientId,
} from '../container';
import type {
  TokenType,
} from '../contexts/UserContext';
import {
  getTokenFromLocalStorage,
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

  return await response.json();
};

export const RefreshToken = async (token: TokenType) => {
  const response = await fetch('/oauth/token', {
    body: JSON.stringify({
      client_id: clientId,
      grant_type: 'refresh_token',
      refresh_token: token.refresh_token,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
    method: 'POST',
  });

  return await response.json();
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

export const hasTokenExpired = () => {
  const token = getTokenFromLocalStorage();

  return (token.created_at + token.expires_in) * 1_000 - Date.now() <= 0;
};
