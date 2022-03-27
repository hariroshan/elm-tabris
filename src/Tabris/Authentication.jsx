import  {authentication} from "tabris"

const Auth = {}
Auth.propNames = ["availableBiometrics"]
Auth.readPropValue = prop => authentication[prop]
Auth.methodCall = (method, args) => authentication[method](...args)
Auth.tagName = 'm-auth'

export default Auth
