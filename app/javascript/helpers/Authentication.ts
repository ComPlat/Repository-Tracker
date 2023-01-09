import {
  clientId,
} from '../container';

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

  localStorage.setItem('token', JSON.stringify(token));
  return token;
};
