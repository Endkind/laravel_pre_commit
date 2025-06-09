import js from '@eslint/js';

export default [
  {
    ...js.configs.recommended,
    languageOptions: {
      ecmaVersion: 2021,
      sourceType: 'module',
      globals: {
        window: 'readonly',
        document: 'readonly',
        localStorage: 'readonly',
        location: 'readonly',
        URL: 'readonly'
      }
    }
  }
];
