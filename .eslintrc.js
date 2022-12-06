// eslint-disable-next-line no-undef, unicorn/prefer-module
module.exports = {
  extends: [
    'canonical',
    'canonical/browser',
    'canonical/module',
  ],
  ignorePatterns: [
    'app/assets/*',
    'node_modules/*',
  ],
  overrides: [
    {
      extends: [
        'canonical/typescript',
      ],
      files: '*.ts',
      parserOptions: {
        project: './tsconfig.json',
      },
      rules: {
        // HINT: Rule conflicts with TS1371: This import is never used as a value and must use 'import type' because 'importsNotUsedAsValues' is set to 'error'.
        'canonical/prefer-inline-type-import': 0,
      },
    },
    {
      extends: [
        'canonical/react',
        'canonical/jsx-a11y',
        'canonical/typescript',
      ],
      files: '*.tsx',
      parserOptions: {
        project: './tsconfig.json',
      },
      rules: {
        // HINT: Rule conflicts with TS1371: This import is never used as a value and must use 'import type' because 'importsNotUsedAsValues' is set to 'error'.
        'canonical/prefer-inline-type-import': 0,
      },
    },
    {
      extends: [
        'canonical/jest',
      ],
      files: '*.test.{ts,tsx}',
      parserOptions: {
        project: './tsconfig.json',
      },
    },
    {
      extends: [
        'canonical/json',
      ],
      files: '*.json',
    },
    {
      extends: [
        'canonical/yaml',
      ],
      files: [
        '*.yaml',
        '*.yml',
      ],
    },
  ],
  root: true,
};
