module Tabris.TextView exposing (Attribute(..), view)

import Html exposing (Html, node)
import Tabris.Widget as Wgt
import Tabris.Common as Common


type Attribute msg
    = Widget (Wgt.Attribute msg)
    | Text String


toAttribute : Attribute msg -> Html.Attribute a
toAttribute attr =
    case attr of
        Text data ->
            Common.text data

        Widget attrb ->
            Wgt.toAttribute attrb


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attrs children =
    node "x-textview" (attrs |> List.map toAttribute) children
