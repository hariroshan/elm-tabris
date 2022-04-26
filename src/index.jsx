import { Window } from 'happy-dom'
// import vmShim from "vm-shim";
// eslint-disable-next-line @typescript-eslint/no-var-requires
const { runInContext } = require("vm-shim");

import Elm from './Main.elm'
import * as allElements from './Tabris'
import * as allMods from './TabrisMods'

import {
    withAttrs,
    withProps,
    withCreate,
    withInitAndUpdate,
    withMountAndRender,
    withUnmount,
} from './mixins'
import { Blob } from 'tabris';
// import Blob from '../node_modules/happy-dom/lib/file/Blob';

const allModsValue = Object.values(allMods)
const allElementsValue = Object.values(allElements)

function getModules(id) {
    if (id.startsWith("m")) {
        return allModsValue
    } else {
        return allElementsValue
    }
}

const handleReadParam = (params, incoming) => {
    const readId = params[0]
    const readProp = params[1]
    getModules(readId).forEach(mod => {
        if (mod.tagName === readId && mod.readPropValue !== undefined && incoming !== undefined) {
            const newData = {
                "x-id": mod.tagName,
                [readProp]: mod.readPropValue(readProp)
            }
            incoming.send(newData)
            // console.log(mod.tagName, newData)
        }
    })
}

const result = {
    ok(val) {
        return { ok: val }
    },
    error(error) {
        return { err: error }
    }
}

async function makeFileObj(path) {
    const blob = await (await fetch(path)).blob();
    const fileName = path.substring(path.lastIndexOf('/') + 1);
    // eslint-disable-next-line no-undef
    return new File([blob], fileName, { type: blob.type });
}

function makeBuffer(param) {
    return (new Blob([param])).arrayBuffer()
}

async function modifyFileTypeArgs(value) {
    if (value.type !== undefined && value.type === "file") {
        if (value.value instanceof Array) {
            const files = await Promise.all(value.value.map(makeFileObj))
            return files
        } else {
            return await makeFileObj(value.value)
        }
    }
    if (value instanceof Array) {
        return await Promise.all(value.map(modifyFileTypeArgs))
    } else if (value instanceof Object) {
        return Object.keys(value).reduce(async (acc, key) => {
            const result = await modifyFileTypeArgs(value[key])
            if (result.length === undefined || result.length > 0) {
                return acc.then(v => {
                    v[key] = result
                    return v
                })
            }
            return acc
        }, Promise.resolve({})).catch(console.error)
    } else {
        return (value)
    }
}

const methodCast = async params => {
    const readId = params[0]
    const readMethod = params[1]
    const readArg = await modifyFileTypeArgs(params[2])
    getModules(readId).forEach(mod => {
        if (mod.tagName === readId && mod.methodCall !== undefined) {
            console.log(readArg)
            mod.methodCall(readMethod, readArg)
            // console.log(mod.tagName, newData)
        }
    })
}
const methodCall = async (params, incoming) => {
    const readId = params[0]
    const readMethod = params[1]
    const readArg = await modifyFileTypeArgs(params[2])
    getModules(readId).forEach(mod => {
        if (mod.tagName === readId && mod.methodCall !== undefined && incoming !== undefined) {
            const returned = mod.methodCall(readMethod, readArg)
            if (returned instanceof Promise) {
                returned.then(e => {
                    const newData = {
                        "x-id": mod.tagName,
                        [readMethod]: result.ok(e === undefined ? null : e)
                    }
                    incoming.send(newData)
                    console.log(mod.tagName, newData)
                    return e
                }).catch(e => {
                    const newData = {
                        "x-id": mod.tagName,
                        [readMethod]: result.error(e === undefined ? null : e)
                    }
                    incoming.send(newData)
                    console.error(e)
                })
            } else {
                const newData = {
                    "x-id": mod.tagName,
                    [readMethod]: returned === undefined ? null : returned
                }
                incoming.send(newData)
            }
        }
    })
}

const eventListener = (params, incoming) => {
    const readId = params[0]
    const readMethod = params[1]
    getModules(readId).forEach(mod => {
        if (mod.tagName === readId && mod.eventCallback !== undefined) {
            const callback = ev => incoming.send({
                "x-id": mod.tagName,
                [readMethod]: ev === undefined ? null : ev
            })
            mod.eventCallback(readMethod, callback)
        }
    })
}

const initElements = params => {
    const { app, window } = params
    const { HTMLElement, customElements } = window

    const mix = (klass, mixin) => mixin(klass)
    const UIElement = app.mixins.reduce(mix, HTMLElement)

    app.elements.forEach(rawElement => {
        const name = rawElement.tagName
        // const Base = withEvent(window.CustomEvent, UIElement, rawElement.event)
        // console.log(name, Base.handlers)
        const element = rawElement.asElement(UIElement, window)
        customElements.define(name, element)
    })
}



function init() {
    /**
     * Create a virtual window and document for executing HTML and JavaScript.
    */
    const window = new Window()
    const document = window.document
    /**
     * Patch `insertBefore` function to default reference node to null when passed undefined.
     * This is technically only needed for an Elm issue in version 1.0.2 of the VirtualDom
     * More context here: https://github.com/elm/virtual-dom/issues/161
     * And here: https://github.com/elm/virtual-dom/blob/1.0.2/src/Elm/Kernel/VirtualDom.js#L1409
    */
    const insertBefore = window.Node.prototype.insertBefore
    window.Node.prototype.insertBefore = function (...args) {
        const [newNode, refNode] = args
        const hasRefNode = args.length > 1
        const isRefNodeDefined = typeof refNode !== 'undefined'
        if (hasRefNode && !isRefNodeDefined)
            return insertBefore.call(this, newNode, null)
        return insertBefore.call(this, ...args)
    }


    /**
     * Build context for web scripts to with:
     * - window
     * - document
     * - all of window globals
     * - the compiled elm app
     * - the app bindings to the native ui
    */

    const app = {
        mixins: [
            withAttrs,
            withProps,
            withCreate,
            withInitAndUpdate,
            withMountAndRender,
            withUnmount
        ],

        elements: Object.values(allElements)
    }

    const context = {
        Elm,
        app,
        window,
        initElements,
        handleReadParam,
        methodCast,
        methodCall,
        eventListener
    }


    /**
     * Required to override for rendering.
     * Seems to be needed by parts of the boot process,
     * if not provided it seems the cordova `document` will be used.
    */

    global.document = document


    /**
     * Define our HTML and JavaScript to load in our virtual document.
    */

    const html = `
      <html>
          <head>
             <title>App</title>
          </head>
          <body>
             <div id='root'>
                <!–– Content will be added here -->
             </div>
          </body>
      </html>
    `

    const customElementScript = `
      initElements({ app, window })
    `


    /**
     * `Elm` is imported as a function since we want to defer executing the
     * compiled JavaScript until it is the virtual document.
     *
     * This is provided by a custom compilation step,
     * which is defined in the `compile-elm-to-bundle` script,
     * located in the root project directory.
    */

    const elmInitScript = `
      const el = Elm().Main.init({
        node: window.document.getElementById('root')
      })
      if (el.ports.read !== undefined) {
        el.ports.read.subscribe(param => {
            handleReadParam(param, el.ports.incoming)
        })
      }
      if (el.ports.methodCast !== undefined) {
        el.ports.methodCast.subscribe(param => {
            methodCast(param)
        })
      }
      if (el.ports.methodCall !== undefined) {
        el.ports.methodCall.subscribe(param => {
            methodCall(param, el.ports.incoming)
        })
      }
      if (el.ports.eventListener !== undefined) {
        el.ports.eventListener.subscribe(param => {
            eventListener(param, el.ports.eventOccured)
        })
      }
    `


    /**
     * Write the html template to the virtual document,
     * and then run scripts to define custom elements and start Elm app.
    */

    document.write(html)
    runInContext(customElementScript, context)
    runInContext(elmInitScript, context)
}

init()

