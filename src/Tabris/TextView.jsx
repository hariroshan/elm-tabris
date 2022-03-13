import { TextView as UITextView } from 'tabris'
import Widget from './Widget'
import Common, { attrsToProps, propNamesToAttrNames, toAttrNameMap } from './Common'

const events = ["tapLink"].concat(Widget.event)

const TextView = {}

TextView.render = Common.render(UITextView)

TextView.asElement = (UIElement, {CustomEvent}) =>
    class TextViewElement extends UIElement {
        static get observedAttributes() {
            return TextView.attributeNames
        }

        init = Common.always(
            Common.initHandlers(CustomEvent, events, this)
        )
        update = Common.update
        attrsToProps = TextView.attrsToProps

        render = (props, context) =>
            TextView.render(props, context, this.handlers || {})
    }


TextView.tagName = 'x-textview'
TextView.propNames =
    [
        "alignment",
        "font",
        "lineSpacing",
        "markupEnabled",
        "maxLines",
        "selectable",
        "text",
        "textColor"
    ]
        .concat(Widget.propNames)

TextView.attributeNames = propNamesToAttrNames(TextView.propNames)
TextView.attributeNameMap = toAttrNameMap(TextView.attributeNames, TextView.propNames)
TextView.attrsToProps = attrsToProps(TextView.attributeNameMap)

export default TextView
