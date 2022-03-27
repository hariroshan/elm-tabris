module Main exposing (..)

import Browser
import Html.Lazy exposing (lazy, lazy2)
import Json.Decode as D
import Tabris as TB
import Tabris.Port as Port
import Tabris.App as App
import Tabris.Authentication as Auth
import Tabris.Button as Button
import Tabris.TextView as TextView
import Tabris.Widget as Widget


type alias Model =
    { count : Int, states : List String }


type Msg
    = Inc
    | Dec
    | Paused
    | Resumed
    | IncomingValue D.Value


init : () -> ( Model, Cmd Msg )
init _ =
    ( { count = 0, states = [] }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        IncomingValue value -> 
            let 
                _ = D.decodeValue TB.decodeIncoming value |> Debug.log "Incoming" -- >> Result.map IncomingValue >> Result. NoOp
            in
            (model, Cmd.none)
        Paused -> 
            ({model | states = "Paused" :: model.states}, Cmd.none)
        Resumed -> 
            ({model | states = "Resumed" :: model.states}, Cmd.none)
        Inc ->
            ( { model | count = model.count + 1 }, Port.read (Auth.readAvailableBiometrics) ) -- "https://google.co.in" App.Files ["sample.png"]  Auth.Title "Check Payment", Auth.SubTitle "Make sure values are correct" 

        Dec ->
            ( { model | count = model.count - 1 }, Cmd.none )


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
    Sub.batch [
        Port.incoming (IncomingValue)
    ]


view : Model -> TB.Node Msg
view model =
    TB.app [ App.OnBackNavigation (D.succeed Paused)]
        [ TB.stack []
            [ lazy2 TB.textView [ TextView.Text (String.fromInt model.count), TextView.Widget (Widget.PaddingXY 20 5) ] []
            , lazy TB.button [ Button.Text "Inc", Button.OnSelect (D.succeed Inc) ]
            , lazy TB.button [ Button.Text "Dec", Button.OnSelect (D.succeed Dec) ]
            , lazy2 TB.textView [ TextView.Text (model.states |> List.foldl (++) ""), TextView.Widget (Widget.PaddingXY 20 5) ] []
            ]
        ]
