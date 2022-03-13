const fs = require('fs').promises
const { compileToString } = require('node-elm-compiler');

/**
 * Note: We save the compilation into the `src` directory to avoid unusual
 * behavior from the `tabris` server. Attempting to move the bundle file may
 * silently break the server, causing the app not to update.
 */
compileToString(
  ['./src/Main.elm'],
  { pathToElm: './node_modules/.bin/elm' }
).then(data => {
  const wrappedCode = wrapElmCode(data);
  return fs.writeFile('./src/elm-dist/elm-bundle.js', wrappedCode);
}).then(() => {
  console.log('Done compiling Elm code');
}).catch((err) => {
  console.log('Oops cannot compile Elm code', err);
});

/**
 * Note: We needed to create a function wrapper around the compiled JavaScript
 * to avoid executing the source when importing the module.
 */
function wrapElmCode (code) {
  return `
    function wrapper() {
      let output = {};
      (function () { ${code} }).call(output);
      return output.Elm;
    }

    export default wrapper;
  `;
}

