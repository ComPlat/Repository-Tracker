// eslint-disable-next-line no-undef, unicorn/prefer-module
module.exports = {
  extends: [
    'canonical',
    'canonical/browser',
    'canonical/module',
  ],
  ignorePatterns: [
    // HINT: Build result
    'app/assets/*',
    // HINT: Dependencies
    'node_modules/*',
    // HINT: PostCSS config does not allow modern JS.
    'postcss.config.js',
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
        // HINT: Rule conflicts with design philosophy and technical implementation of AntDesign, see:
        //       https://ant.design/docs/react/customize-theme
        //       https://ant.design/docs/blog/css-in-js
        'react/forbid-component-props': [
          2,
          {
            forbid: [
              {
                allowedFor: [
                  'Select',
                  'SearchOutlined',
                  'Header',
                ],
                propName: 'style',
              },
            ],
          },
        ],
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
