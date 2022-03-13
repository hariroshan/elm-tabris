module Main exposing (..)

import Browser
import Html.Lazy exposing (lazy, lazy2)
import Json.Decode as D
import Tabris as TB
import Tabris.Button as Button
import Tabris.TextView as TextView
import Tabris.Widget as Widget
import Tabris.App as App


type alias Model =
    Int


type Msg
    = Inc
    | Dec


init : () -> ( Model, Cmd Msg )
init _ =
    ( 0, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Inc ->
            ( model + 1, Cmd.none )

        Dec ->
            ( model - 1, Cmd.none )


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> TB.Node Msg
view model =
    TB.app [App.IdleTimeoutEnabled True]
        [ TB.stack []
            [ lazy2 TB.textView [ TextView.Text (String.fromInt model), TextView.Widget(Widget.PaddingXY 20 5)] []
            , lazy TB.button [ Button.Text "Inc", Button.OnSelect (D.succeed Inc) ]
            , lazy TB.button [ Button.Text "Dec", Button.OnSelect (D.succeed Dec) ]
            ]
        ]
