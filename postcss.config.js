module.exports = {
  plugins: {
    // require('postcss-import'),
    tailwindcss: {},
    'postcss-nested': {},
    'postcss-flexbugs-fixes': {},
    'postcss-preset-env': {
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    },
  }
}
