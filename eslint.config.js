const globals = require("globals");
const js = require("@eslint/js");

module.exports = [
  // Apply recommended rules to all files
  js.configs.recommended,

  // Configuration for Browser/Frontend JavaScript files
  {
    files: ["js/**/*.js"],
    languageOptions: {
      sourceType: "module",
      ecmaVersion: "latest",
      globals: {
        ...globals.browser,
      },
    },
    rules: {
      "no-unused-vars": "warn",
    },
  },

  // Configuration for Node.js scripts in the root directory
  {
    files: ["*.js"],
    languageOptions: {
      sourceType: "commonjs",
      ecmaVersion: "latest",
      globals: {
        ...globals.node,
      },
    },
    rules: {
        "no-unused-vars": "warn",
    }
  },

  // Global ignore patterns
  {
    ignores: ["node_modules/", ".git/", "docs/", "scripts/"],
  },
];
