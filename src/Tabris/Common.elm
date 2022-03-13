module Tabris.Common exposing (..)
import Html.Attributes exposing (attribute)
import Html


text : String -> Html.Attribute msg
text = 
    attribute "text" 

fromBool : Bool -> String
fromBool bool = 
    if bool then "true" else "false"