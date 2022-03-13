module Tabris.Button exposing (AlignmentValue(..), Attribute(..), view)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Html.Events exposing (on)
import Json.Decode as D
import Tabris.Common as Common
import Tabris.Widget as Wgt


type StyleValue
    = Elevate
    | Default
    | Outline
    | Flat
    | TextOnly


type AlignmentValue
    = CenterX
    | Left
    | Right


type Attribute msg
    = Widget (Wgt.Attribute msg)
    | Text String
    | Alignment AlignmentValue
    | OnSelect (D.Decoder msg)
    | Style StyleValue


toAttribute : Attribute msg -> Html.Attribute msg
toAttribute attr =
    case attr of
        Widget at ->
            Wgt.toAttribute at

        Text data ->
            Common.text data

        Alignment align ->
            attribute "alignment"
                (case align of
                    CenterX ->
                        "centerX"

                    Left ->
                        "left"

                    Right ->
                        "right"
                )

        OnSelect decoder ->
            on "select" decoder

        Style styleValue ->
            attribute "style"
                (case styleValue of
                    Default ->
                        "default"

                    Elevate ->
                        "elevate"

                    Flat ->
                        "flat"

                    Outline ->
                        "outline"

                    TextOnly ->
                        "text"
                )


view : List (Attribute msg) -> Html msg
view attrs =
    node "x-button" (attrs |> List.map toAttribute) []
