module.exports = {
  mode: 'jit',
  content: [
    "./app/javascript/stylesheets/**/*.*css",
    "./app/javascript/controllers/*.js",
    "./app/views/**/*.*",
    "./app/components/*.*",
    "./app/helpers/**/*.*",
  ],
  darkMode: 'media', // or 'media' or 'class'
  variants: {
    extend: {
      backgroundColor: ['odd', 'even'],
      margin: ['dark'],
    }
  },
  theme: {
    extend: {
      fontFamily: {
        'mono-cn': `'Sarasa Gothic SC', 'Source Code Pro','DejaVu Sans Mono','Ubuntu Mono','Anonymous Pro','Droid Sans Mono',Menlo,Monaco,Consolas,Inconsolata,Courier,monospace,'PingFang SC','Microsoft YaHei',sans-serif`,
      },
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
  plugins: [
    require('daisyui'),
    require('@tailwindcss/forms'),
  ],
}
