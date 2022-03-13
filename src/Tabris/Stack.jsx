import { Stack as UIStack } from 'tabris'
import Widget from './Widget'

import Common, { attrsToProps, propNamesToAttrNames, toAttrNameMap } from './Common'

const Stack = {}

Stack.render = Common.render(UIStack)

Stack.asElement = (UIElement, {CustomEvent}) =>
    class StackElement extends UIElement {
        static get observedAttributes() {
            return Stack.attributeNames
        }

        init =  Common.always(
            Common.initHandlers(CustomEvent,  Widget.event, this)
        )
        update = Common.update
        attrsToProps = Stack.attrsToProps

        render = (props, context) =>
            Stack.render(props, context, this.handlers || {})
    }

Stack.tagName = 'x-stack'
Stack.propNames =
    ['alignment',
        'layout',
        'spacing'
    ].concat(Widget.propNames)

Stack.attributeNames = propNamesToAttrNames(Stack.propNames)
Stack.attributeNameMap = toAttrNameMap(Stack.attributeNames, Stack.propNames)
Stack.attrsToProps = attrsToProps(Stack.attributeNameMap)

export default Stack
