import type {
  FormRule,
} from 'antd';

const numberPattern = /(?=.*\d)/u;
const uppercasePattern = /(?=.*[A-Z])/u;
const lowercasePattern = /(?=.*[a-z])/u;
const specialCharacterPattern = /[^\w\s]/u;
const whiteSpacePattern = /^\S*$/u;

export const atLeastSixCharactersLong: FormRule = {
  message: 'Password must be at least 6 characters long',
  min: 6,
};

export const atLeastOneNumber: FormRule = {
  message: 'Password must have at least 1 number',
  pattern: numberPattern,
};

export const atLeastOneUppercaseLetter: FormRule = {
  message: 'Password must have at least 1 uppercase letter',
  pattern: uppercasePattern,
};

export const atLeastOneLowercaseLetter: FormRule = {
  message: 'Password must have at least 1 lowercase letter',
  pattern: lowercasePattern,
};

export const atLeastOneSpecialCharacter: FormRule = {
  message: 'Password must have at least 1 special character',
  pattern: specialCharacterPattern,
};

export const noWhitespaces: FormRule = {
  message: 'Password must not contain whitespaces!',
  pattern: whiteSpacePattern,
};

export const notEmpty: FormRule = {
  message: 'Password field must not be empty!',
  required: true,
};

export const regexRuleType: FormRule = {
  type: 'regexp',
};
