const NewToken = async () => {
  const token = await fetch('/oauth/token', {
    body: JSON.stringify({
      client_id: 'PHfCi_BMBe5b731l2mQaFaWMbJ6fZTxYOir7T89kBis',
      grant_type: 'refresh_token',
      refresh_token: JSON.parse(localStorage.getItem('token') as string).refresh_token,
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

export const Token = async (email: string, password: string) => {
  const token = await fetch('/oauth/token', {
    body: JSON.stringify({
      client_id: 'PHfCi_BMBe5b731l2mQaFaWMbJ6fZTxYOir7T89kBis',
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

export const Register = async (email: string, password: string) => {
  await fetch('/users', {
    body: JSON.stringify({
      user: {
        email,
        name: 'name',
        password,
        role: 'user',
      },
    }),
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
    method: 'POST',
  });
};
