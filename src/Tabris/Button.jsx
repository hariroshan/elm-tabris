import { Button as UIButton } from 'tabris'
import Widget from './Widget'

import Common, { attrsToProps, propNamesToAttrNames, toAttrNameMap, initHandlers, always } from './Common'
const events = ['select'].concat(Widget.event)

const Button = {}

Button.render = Common.render(UIButton)

Button.tagName = 'x-button'
Button.propNames =
    ['alignment',
        'autoCapitalize',
        'font',
        'image',
        'imageTintColor',
        'strokeColor',
        'strokeWidth',
        'style',
        'text',
        'textColor']
        .concat(Widget.propNames)

Button.attributeNames = propNamesToAttrNames(Button.propNames)
Button.attributeNameMap = toAttrNameMap(Button.attributeNames, Button.propNames)
Button.attrsToProps = attrsToProps(Button.attributeNameMap)

Button.asElement = (UIElement, { CustomEvent }) =>
    class ButtonElement extends UIElement {
        static get observedAttributes() {
            return Button.attributeNames
        }

        init = always(
            initHandlers(CustomEvent, events, this)
        )
        update = Common.update
        attrsToProps = Button.attrsToProps

        render = (props, context) => {
            return Button.render(props, context, this.handlers || {})
        }
    }

export default Button
