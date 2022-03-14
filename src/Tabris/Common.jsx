export const toLower = string =>
    string.toLowerCase()

export const propNamesToAttrNames = propNames =>
    propNames.map(toLower)

export const toAttrNameMap = (attrNames, propNames) =>
    attrNames.reduce((nameMap, attrName, index) => {
        return Object.assign(nameMap, {
            [attrName]: propNames[index]
        })
    }, {})

export const attrsToProps = attrNameMap => attrs => {
    const keys = Object.keys(attrs)
    const toPropName = attrName => attrNameMap[attrName]

    return keys.reduce((props, attrName) => {
        return Object.assign(props, {
            [toPropName(attrName)]: attrs[attrName]
        })
    }, {})
}
export const ignore = a => a

export const capitalize = string =>
    string.charAt(0).toUpperCase() + string.slice(1);

export const update = (props, view) => Object.assign(view, props)

export const render = element => (props, context, handlers) => {
    const { contentView } = context
    const Element = element
    const view =
        <Element {...props} {...handlers} />

    contentView.append(view)
    return view
}

export const initHandlers = (CustomEvent, events, object) =>
    events.reduce((klass, evt) => {
        const key = "on" + capitalize(evt)
        klass[key] = ((e) => {
            console.log("event", key)
            klass.dispatchEvent(new CustomEvent(evt, { dataEvent: e }))
        })
        klass.handlers = Object.assign(klass.handlers || {}, { [key]: klass[key] })
        return klass
    }, object)

export const always = a => _ => a

export default {
    render,
    update,
    capitalize,
    ignore,
    attrsToProps,
    toAttrNameMap,
    toLower,
    propNamesToAttrNames,
    always,
    initHandlers
}
