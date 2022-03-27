module Tabris.App exposing
    ( Attribute(..)
    , Method
    , Props
    , ShareData(..)
    , decodeMethods
    , decodeProps
    , methodGetResourceLocation
    , methodLaunchUrl
    , methodRegisterFont
    , methodReload
    , methodShare
    , readId
    , readIdleTimeoutEnabled
    , tagName
    , view
    )

import Array exposing (Array)
import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E
import Tabris.Common exposing (decodeResult, fromBool, makeFileType)


type Method
    = GetResourceLocation String
    | LaunchUrl (Result String ())
    | RegisterFont
    | Reload
    | Share (Result String String)


type Props
    = IdProp String
    | IdleTimeoutEnabledProp Bool
    | DebugBuildProp Bool
    | Version String
    | VersionCode Float


type ShareData
    = Title String
    | Text String
    | Url String
    | Files (List String)


tagName : String
tagName =
    "x-app"


idProp : String
idProp =
    "id"


idleTimeoutEnabledProp : String
idleTimeoutEnabledProp =
    "idleTimeoutEnabled"


debugBuild : String
debugBuild =
    "debugBuild"


version : String
version =
    "version"


versionCode : String
versionCode =
    "versionCode"


launch : String
launch =
    "launch"


getResourceLocation : String
getResourceLocation =
    "getResourceLocation"


registerFont : String
registerFont =
    "registerFont"


reload : String
reload =
    "reload"


share : String
share =
    "share"


readId : ( String, String )
readId =
    ( tagName, idProp )


readIdleTimeoutEnabled : ( String, String )
readIdleTimeoutEnabled =
    ( tagName, idleTimeoutEnabledProp )


methodLaunchUrl : String -> ( String, String, Array E.Value )
methodLaunchUrl url =
    ( tagName, launch, [ E.string url ] |> Array.fromList )


methodRegisterFont : String -> String -> ( String, String, Array E.Value )
methodRegisterFont fontAlias filePath =
    ( tagName, registerFont, [ E.string fontAlias, E.string filePath ] |> Array.fromList )


methodReload : Maybe String -> ( String, String, Array E.Value )
methodReload url =
    ( tagName
    , reload
    , url
        |> Maybe.map (E.string >> List.singleton >> Array.fromList)
        |> Maybe.withDefault Array.empty
    )


methodShare : List ShareData -> ( String, String, Array E.Value )
methodShare shareList =
    ( tagName
    , share
    , shareList
        |> List.map
            (\d ->
                case d of
                    Title title ->
                        ( "title", E.string title )

                    Text text ->
                        ( "text", E.string text )

                    Url url ->
                        ( "url", E.string url )

                    Files filepaths ->
                        ( "files"
                        , makeFileType (E.list E.string filepaths)
                        )
            )
        |> E.object
        |> List.singleton
        |> Array.fromList
    )


methodGetResourceLocation : String -> ( String, String, Array E.Value )
methodGetResourceLocation path =
    ( tagName, getResourceLocation, [ E.string path ] |> Array.fromList )


decodeProps : Decoder Props
decodeProps =
    D.oneOf
        [ D.field idProp D.string |> D.map IdProp
        , D.field idleTimeoutEnabledProp D.bool |> D.map IdleTimeoutEnabledProp
        , D.field debugBuild D.bool |> D.map DebugBuildProp
        , D.field version D.string |> D.map Version
        , D.field versionCode D.float |> D.map VersionCode
        ]


decodeMethods : Decoder Method
decodeMethods =
    D.oneOf
        [ D.field getResourceLocation D.string |> D.map GetResourceLocation
        , D.field launch (decodeResult { ok = D.null (), err = D.string } |> D.map LaunchUrl)
        , D.field share (decodeResult { ok = D.string, err = D.string } |> D.map Share)
        , D.field registerFont (D.null RegisterFont)
        , D.field reload (D.null Reload)
        ]


type Attribute msg
    = IdleTimeoutEnabled Bool
    | OnBackNavigation (Decoder msg)
    | OnBackground (Decoder msg)
    | OnForeground (Decoder msg)
    | OnKeyPress (Decoder msg)
    | OnPause (Decoder msg)
    | OnResume (Decoder msg)
    | OnTerminate (Decoder msg)


toAttribute : Attribute msg -> Html.Attribute msg
toAttribute attr =
    case attr of
        IdleTimeoutEnabled bool ->
            attribute "idletimeoutenabled" (fromBool bool)

        OnBackNavigation decoder ->
            on "backNavigation" decoder

        OnBackground decoder ->
            on "background" decoder

        OnForeground decoder ->
            on "foreground" decoder

        OnKeyPress decoder ->
            on "keyPress" decoder

        OnPause decoder ->
            on "pause" decoder

        OnResume decoder ->
            on "resume" decoder

        OnTerminate decoder ->
            on "terminate" decoder


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attr children =
    node tagName (attr |> List.map toAttribute) children
