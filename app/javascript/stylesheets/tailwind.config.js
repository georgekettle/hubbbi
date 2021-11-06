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
      red: colors.rose,
      yellow: colors.amber,
      green: colors.emerald,
      // generate these below at www.tailwindshades.com
      contrast: {
        DEFAULT: '#FFA80A',
        '50': '#fbf9f7',
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
    screens: {
      'xs': '480px',
      // => @media (min-width: 480px) { ... }
      'sm': '640px',
      // => @media (min-width: 640px) { ... }

      'md': '768px',
      // => @media (min-width: 768px) { ... }

      'lg': '1024px',
      // => @media (min-width: 1024px) { ... }

      'xl': '1280px',
      // => @media (min-width: 1280px) { ... }

      '2xl': '1536px',
      // => @media (min-width: 1536px) { ... }
    },
    extend: {},
  },
  variants: {
    extend: {
      scale: ['group-hover'],
      height: ['group-hover'],
      display: ['group-hover'],
    }
  },
  plugins: [
    require('@tailwindcss/line-clamp'),
    require('@tailwindcss/aspect-ratio'),
  ],
}
