import  {device} from "tabris"

const Device = {}
Device.readPropValue = prop => device[prop]
Device.eventCallback = (method, callback) => device[method](callback)
Device.tagName = 'm-device'

export default Device
