module Components.Icon exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type Variants
  = Default
  | Small
  | Large


type alias Options =
  { name : String
  , variant: Variants }


view : List (Attribute msg) -> Options -> Html.Html msg
view props options =
  let
    variant =
      case options.variant of
        Default -> "Icon--default"
        Small -> "Icon--small"
        Large -> "Icon--large"
  in
    div
      (List.append
        [ class "Icon"
        , class variant
        , class ("Icon--" ++ options.name) ]
        props)
      [ ]
