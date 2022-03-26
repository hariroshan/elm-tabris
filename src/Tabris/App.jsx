import  {app, Composite, contentView as rootView } from "tabris"
import  { attrsToProps, initHandlers, propNamesToAttrNames, toAttrNameMap } from './Common'

const events = [
  "backNavigation",
  "background",
  "foreground",
  "keyPress",
  "pause",
  "resume",
  "terminate"
]
const App = {
  render (props, context) {
    const { contentView = rootView } = context
    const view = <Composite />
    contentView.append(view)
    return view
  },
}
const getParsedProps = (props) => Object.keys(props).reduce((acc, cur) => Object.assign(acc, {[cur]: JSON.parse(props[cur])}), {})

App.asElement = (UIElement, {CustomEvent}) =>
  class AppElement extends UIElement {
    static get observedAttributes() {
      return App.attributeNames
    }
    init = props => {
        const mappedProps = getParsedProps(props)
        initHandlers(CustomEvent, events, this)
        Object.assign(app, mappedProps)
        Object.keys(this.handlers).forEach(key => {
          app[key](this.handlers[key])
        })
    }
    update = (props, view) => {
      const mappedProps = getParsedProps(props)
        Object.assign(app, mappedProps)
        return view
    }
    render = App.render
    attrsToProps = App.attrsToProps
  }

App.tagName = 'x-app'
App.readPropValue = prop => app[prop]
App.methodCall = (method, args) => app[method](...args)
App.propNames = ["idleTimeoutEnabled"]
App.attributeNames = propNamesToAttrNames(App.propNames)
App.attributeNameMap = toAttrNameMap(App.attributeNames, App.propNames)
App.attrsToProps = attrsToProps(App.attributeNameMap)

export default App
