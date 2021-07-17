const colors = require('tailwindcss/colors');

module.exports = {
  important: true,
  purge: [],
  darkMode: false, // or 'media' or 'class'
  theme: {
    fontFamily: {
      sans: ['Shape', 'Helvetica', 'sans-serif']
    },
    colors: {
      transparent: 'transparent',
      current: 'currentColor',
      black: colors.black,
      white: colors.white,
      gray: colors.trueGray,
      indigo: colors.indigo,
      red: colors.rose,
      yellow: colors.amber,
      green: colors.emerald,
      // generate these below at www.tailwindshades.com
      contrast: {
        DEFAULT: '#FFA80A',
        '50': '#FFFDFC',
        '100': '#FFF1D6',
        '200': '#FFDFA3',
        '300': '#FFCD70',
        '400': '#FFBA3D',
        '500': '#FFA80A',
        '600': '#D68A00',
        '700': '#A36A00',
        '800': '#704900',
        '900': '#3D2800'
      },
      primary: {
        DEFAULT: '#673A83',
        '50': '#ECE3F3',
        '100': '#E1D1EB',
        '200': '#CAAEDB',
        '300': '#B38ACC',
        '400': '#9C67BC',
        '500': '#8349A6',
        '600': '#673A83',
        '700': '#4B2A60',
        '800': '#2F1A3C',
        '900': '#140B19'
      },
    },
    extend: {},
  },
  variants: {
    extend: {},
  },
  plugins: [],
}
