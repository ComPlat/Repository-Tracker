import {
  csrfToken,
} from '../container';

export const Register = async (email: string, password: string) => {
  const response = await fetch('/users', {
    body: JSON.stringify({
      user: {
        email,
        name: 'name',
        password,
        role: 'user',
      },
    }),
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-TOKEN': csrfToken,
    },
    method: 'POST',
  });

  return await response.json();
};
