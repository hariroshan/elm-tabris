import path from 'path'
import typescript from '@rollup/plugin-typescript'
import elm from './elm-rollup-plugin'

export default {
  input: 'src/index.jsx',
  output: {
    file: 'dist/index.js',
    format: 'cjs',
    exports: 'auto',
  },
  external: [ 'buffer' ],
  plugins: [
    typescript({
      tsconfig: './tsconfig.json',
      include: [
        "./src/**/*.ts",
        "./src/**/*.tsx",
        "./src/**/*.js",
        "./src/**/*.jsx"
      ]
    }),
    elm({
      pathToElm: path.resolve(__dirname, 'node_modules/elm/bin/elm')
    })
  ]
};
