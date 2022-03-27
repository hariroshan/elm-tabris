module Tabris.Common exposing (..)

import Html
import Html.Attributes exposing (attribute)
import Json.Decode as D exposing (Decoder)
import Json.Encode as E


text : String -> Html.Attribute msg
text =
    attribute "text"


fromBool : Bool -> String
fromBool bool =
    if bool then
        "true"

    else
        "false"


decodeResult : { ok : Decoder value, err : Decoder error } -> Decoder (Result error value)
decodeResult { ok, err } =
    D.oneOf
        [ D.field "ok" ok |> D.map Ok
        , D.field "err" err |> D.map Err
        ]


makeFileType : E.Value -> E.Value
makeFileType value =
    E.object
        [ ( "type", E.string "file" )
        , ( "value", value )
        ]
