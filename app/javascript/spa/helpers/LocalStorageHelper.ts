export const getUserFromLocalStorage = () => {
  return JSON.parse(localStorage.getItem('user') as string);
};

export const getTokenFromLocalStorage = () => {
  return JSON.parse(localStorage.getItem('user') as string).token;
};

export const storeUserInLocalStorage = (user: Object) => {
  localStorage.setItem('user', JSON.stringify(user));
};
