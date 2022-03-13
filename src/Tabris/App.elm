module Tabris.App exposing (Attribute(..),  view)

import Html exposing (Html, node)
import Html.Events exposing (on)
import Json.Decode exposing (Decoder)
import Html.Attributes exposing (attribute)
import Tabris.Common exposing (fromBool)


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
    node "x-app" (attr |> List.map toAttribute) children
