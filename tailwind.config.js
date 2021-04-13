module.exports = {
  mode: 'jit',
  purge: {
    content: [
      "./app/javascript/stylesheets/**/*.*css",
      "./app/javascript/controllers/*.js",
      "./app/views/**/*.*",
      "./app/components/*.*",
      "./app/helpers/**/*.*",
    ],
    options: {
      whitelist: [],
    },
  },
  darkMode: 'media', // or 'media' or 'class'
  theme: {
    extend: {
      height: {},
      maxHeight: {
        '0': '0',
        '1/4': '25%',
        '1/2': '50%',
        '3/4': '75%',
        '4/5': '80%',
        'full': '100%',
      },
      zIndex: {
        '60': '60',
        '-10': '-10',
      }
    },
  },
  variants: {
    extend: {
      backgroundColor: ['odd', 'even'],
      margin: ['dark'],
    }
  },
  plugins: [
    require('@tailwindcss/forms'),
  ],
}