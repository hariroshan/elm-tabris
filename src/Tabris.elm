module Tabris exposing (..)

import Tabris.TextView as TextView
import Tabris.Button as Button
import Tabris.Stack as Stack
import Tabris.App as App
import Html exposing (Html)

type alias Node msg = Html msg


textView : List (TextView.Attribute msg) -> List (Node msg) -> Node msg
textView = TextView.view


button : List (Button.Attribute msg) -> Node msg
button = Button.view


stack : List (Stack.Attribute msg) -> List (Node msg) -> Node msg
stack = Stack.view


app : List (App.Attribute msg) -> List (Node msg) -> Node msg
app = App.view

