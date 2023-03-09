const numberPattern = /(?=.*\d)/u;
const uppercasePattern = /(?=.*[A-Z])/u;
const lowercasePattern = /(?=.*[a-z])/u;
const specialCharacterPattern = /[^\w\s]/u;
const whiteSpacePattern = /^\S*$/u;

export const atLeastSixCharactersLong = {
  message: 'Password must be at least 6 characters long',
  min: 6,
};

export const atLeastOneNumber = {
  message: 'Password must have at least 1 number',
  pattern: numberPattern,
};

export const atLeastOneUppercaseLetter = {
  message: 'Password must have at least 1 uppercase letter',
  pattern: uppercasePattern,
};

export const atLeastOneLowercaseLetter = {
  message: 'Password must have at least 1 lowercase letter',
  pattern: lowercasePattern,
};

export const atLeastOneSpecialCharacter = {
  message: 'Password must have at least 1 special character',
  pattern: specialCharacterPattern,
};

export const noWhitespaces = {
  message: 'Password must not contain whitespaces!',
  pattern: whiteSpacePattern,
};
