module Tabris exposing (..)

import Html exposing (Html)
import Json.Decode as D exposing (Decoder)
import Tabris.App as App
import Tabris.Authentication as Authentication
import Tabris.Button as Button
import Tabris.Stack as Stack
import Tabris.TextView as TextView


type alias Node msg =
    Html msg


type Incoming
    = AppProps App.Props
    | AppMethod App.Method
    | AuthenticationProps Authentication.Props
    | AuthenticationMethod Authentication.Method


textView : List (TextView.Attribute msg) -> List (Node msg) -> Node msg
textView =
    TextView.view


button : List (Button.Attribute msg) -> Node msg
button =
    Button.view


stack : List (Stack.Attribute msg) -> List (Node msg) -> Node msg
stack =
    Stack.view


app : List (App.Attribute msg) -> List (Node msg) -> Node msg
app =
    App.view


decodeIncoming : Decoder Incoming
decodeIncoming =
    D.andThen
        (\id ->
            if App.tagName == id then
                D.oneOf
                    [ App.decodeProps |> D.map AppProps
                    , App.decodeMethods |> D.map AppMethod
                    ]
            else if Authentication.tagName == id then
                D.oneOf
                    [ Authentication.decodeProps |> D.map AuthenticationProps 
                    , Authentication.decodeMethods |> D.map AuthenticationMethod
                    ]

            else
                D.fail "Unknown body"
        )
        (D.field "x-id" D.string)
