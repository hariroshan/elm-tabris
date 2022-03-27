module Tabris.Device exposing (..)


type alias CameraProps =
    { id : String
    , active : Bool
    , captureResolution : Maybe { width : Int, height : Int }
    , position : String
    , availableCaptureResolutions : List { width : Int, height : Int }
    }


type Props
    = Cameras (List CameraProps)
    | Language
    | Model
    | Name
    | Orientation
    | Platform
    | ScaleFactor
    | ScreenHeight
    | ScreenWidth
    | Vendor
    | Version


cameras : String
cameras =
    "cameras"


language : String
language =
    "language"


model : String
model =
    "model"


name : String
name =
    "name"


orientation : String
orientation =
    "orientation"


platform : String
platform =
    "platform"


scaleFactor : String
scaleFactor =
    "scaleFactor"


screenHeight : String
screenHeight =
    "screenHeight"


screenWidth : String
screenWidth =
    "screenWidth"


vendor : String
vendor =
    "vendor"


version : String
version =
    "version"
