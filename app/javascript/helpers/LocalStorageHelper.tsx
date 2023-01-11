export const getUserFromLocalStorage = () => {
  return JSON.parse(localStorage.getItem('user') as string);
};

export const getTokenFromLocalStorage = () => {
  return JSON.parse(localStorage.getItem('token') as string);
};

export const storeUserInLocalStorage = (user: Object) => {
  localStorage.setItem('user', JSON.stringify(user));
};

export const storeTokenInLocalStorage = (token: Object) => {
  localStorage.setItem('token', JSON.stringify(token));
};

export const removeUserFromLocalStorage = (userKey: string) => {
  localStorage.removeItem(userKey);
};
