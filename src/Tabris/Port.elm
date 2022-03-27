port module Tabris.Port exposing (..)

import Json.Decode as D
import Array exposing (Array)


port read : ( String, String ) -> Cmd msg


port incoming : (D.Value -> msg) -> Sub msg

port eventOccured : (D.Value -> msg) -> Sub msg

port methodCast :
    ( String, String, Array D.Value )
    -> Cmd msg -- Value of method call is discarded


port methodCall :
    ( String, String, Array D.Value )
    -> Cmd msg -- Value of method call is push through incoming port

port eventListener : ( String, String ) -> Cmd msg
