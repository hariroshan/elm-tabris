module Tabris.Stack exposing (Attribute(..),  view)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)


type AlignmentValue
    = CenterX
    | StretchX
    | Left
    | Right


type Attribute msg
    = Alignment AlignmentValue


toAttribute : Attribute msg -> Html.Attribute msg
toAttribute attr =
    case attr of
        Alignment align ->
            attribute "alignment"
                (case align of
                    CenterX ->
                        "centerX"

                    StretchX ->
                        "stretchX"

                    Left ->
                        "left"

                    Right ->
                        "right"
                )


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attrs children =
    node "x-stack" (attrs |> List.map toAttribute) children
