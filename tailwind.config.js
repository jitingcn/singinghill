module.exports = {
  mode: 'jit',
  content: [
    "./app/javascript/**/*.*css",
    "./app/javascript/**/*.js",
    "./app/views/**/*.*",
    "./app/components/*.*",
    "./app/helpers/**/*.*",
  ],
  darkMode: 'media', // or 'media' or 'class'
  variants: {
    extend: {}
  },
  theme: {
    extend: {
      fontFamily: {
        'mono-cn': `'Sarasa Gothic SC', 'DejaVu Sans Mono', 'Ubuntu Mono','Anonymous Pro','Droid Sans Mono',Menlo,Monaco,Consolas,Inconsolata,Courier,monospace,'PingFang SC','Microsoft YaHei',sans-serif`,
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
    // require('@tailwindcss/forms'),
    require('daisyui'),
  ],
  daisyui: {
    themes: false, // false: only light + dark | true: all themes | array: specific themes like this ["light", "dark", "cupcake"]
    darkTheme: "dark", // name of one of the included themes for dark mode
    base: true, // applies background color and foreground color for root element by default
    styled: true, // include daisyUI colors and design decisions for all components
    utils: true, // adds responsive and modifier utility classes
    prefix: "", // prefix for daisyUI classnames (components, modifiers and responsive class names. Not colors)
    logs: true, // Shows info about daisyUI version and used config in the console when building your CSS
    themeRoot: ":root", // The element that receives theme color CSS variables
  },
}
