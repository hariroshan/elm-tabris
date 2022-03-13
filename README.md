# Elm Happydom Tabris Experiment

## About Experiment
In short, this is a fun project showcasing a potential path for developing Native UI apps with Elm and Custom Elements. Hope you find it interesting and/or useful 😁

## Install Dependencies

First install project dependencies:

```
npm install
```

## Build Elm Source

Next we need to run a node script for building the Elm source code.
From the project root:

```
node compile-elm-to-bundle.js
```

## Run

Then in the project directory, type:

```
npm start
```


This will start a Tabris.js code server at a free port and print its URL to the console. The app code can then be [side-loaded](https://docs.tabris.com/3.6/developer-app.html#run-your-app) in the [developer app](https://docs.tabris.com/3.6/developer-app.html) by entering that URL.

Alternatively you can also call the Tabris CLI directly:

```
npx tabris serve -a -w
```

This the same as running `npm start`. The `-w` switch starts the compiler in watch mode, meaning you do not have to re-start the server after each code change, and `-a` causes the app to reload automatically as well.


## Debugging


### Android

Tabris on Android supports any debugger that uses the V8 inspector protocol. This includes Visual Studio Code, WebStorm and the Chrome Browser. More information can be found [here](https://docs.tabris.com/3.6/debug.html#android).

### iOS

On iOS, the Safari developer tools [can be used for debugging](https://docs.tabris.com/3.6/debug.html#ios).
## Build

The app can be built using the online build service at [tabrisjs.com](https://tabrisjs.com) or locally using [Tabris.js CLI](https://www.npmjs.com/package/tabris-cli).

See [Building a Tabris.js App](https://docs.tabris.com/3.6/build.html) for more information.
