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
