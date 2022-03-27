module Tabris.Device exposing
    ( CameraProps
    , Event(..)
    , Orientation(..)
    , Platform(..)
    , Props(..)
    , decodeEvent
    , eventOrientationChanged
    , tagName
    )

import Json.Decode as D


tagName : String
tagName =
    "m-device"


type alias CameraProps =
    { id : String
    , active : Bool
    , captureResolution : Maybe { width : Int, height : Int }
    , position : String
    , availableCaptureResolutions : List { width : Int, height : Int }
    }


type Orientation
    = PortraitPrimary
    | PortraitSecondary
    | LandscapePrimary
    | LandscapeSecondary


decodeOrientation : D.Decoder Orientation
decodeOrientation =
    D.string
        |> D.andThen
            (\str ->
                case str of
                    "portrait-primary" ->
                        D.succeed PortraitPrimary

                    "portrait-secondary" ->
                        D.succeed PortraitSecondary

                    "landscape-primary" ->
                        D.succeed LandscapePrimary

                    "landscape-secondary" ->
                        D.succeed LandscapeSecondary

                    _ ->
                        D.fail ("unknown orientation " ++ str)
            )


type Platform
    = Andriod
    | IOS


type Props
    = Cameras (List CameraProps)
    | Language String
    | Model String
    | Name String
    | Orientation Orientation
    | Platform Platform
    | ScaleFactor Float
    | ScreenHeight Int
    | ScreenWidth Int
    | Vendor String
    | Version String


type Event
    = OrientationChanged Orientation


onOrientationChanged : String
onOrientationChanged =
    "onOrientationChanged"


eventOrientationChanged : ( String, String )
eventOrientationChanged =
    ( tagName, onOrientationChanged )


decodeEvent : D.Decoder Event
decodeEvent =
    D.oneOf
        [ D.field onOrientationChanged (D.field "value" decodeOrientation) |> D.map OrientationChanged
        ]


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
