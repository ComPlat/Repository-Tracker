import {
  clientId,
} from '../container';

export const Token = async (email: string, password: string) => {
  const token = await fetch('/oauth/token', {
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
  }).then(async (response) => {
    return await response.json();
  }).then((item) => {
    return item;
  });

  localStorage.setItem('token', JSON.stringify(token));
  return token;
};
