module Components.Icon exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Options msg =
  { name : String
  , variant : Variants
  , attributes : List (Attribute msg) }


type Variants
  = Default
  | Small
  | Large


view : Options msg -> Html.Html msg
view options =
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
        options.attributes)
      [ ]
