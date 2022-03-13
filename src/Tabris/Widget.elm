module Tabris.Widget exposing (Attribute(..), toAttribute, AnimationEasing(..), AnimationOptions(..))

import Html
import Html.Attributes exposing (property)
import Json.Encode as Json

type AnimationEasing
    = Linear 
    | EaseIn
    | EaseOut 
    | EaseInOut 
    


type AnimationOptions
    = Delay Int 
    | Duration Int 
    | Easing AnimationEasing
    | Repeat Int 
    | Reverse Bool 
    | Name String


type alias BoxDimension =
    { left : Int
    , right : Int
    , top : Int
    , bottom : Int
    }


type Attribute msg
    = Padding BoxDimension
    | PaddingAll Int
    | PaddingXY Int Int


padding : List Int -> Html.Attribute msg
padding data =
    property "padding" (Json.list Json.int data)


toAttribute : Attribute msg -> Html.Attribute a
toAttribute attr =
    case attr of
        Padding data ->
            padding [ data.top, data.right, data.bottom, data.left ]

        PaddingAll data ->
            padding [ data ]

        PaddingXY x y ->
            padding [ y, x ]

