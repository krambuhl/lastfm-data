module Tags.Padding exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Options msg =
  { variant : Variants
  , attributes : List (Attribute msg) }


type Variants
  = Default
  | Small
  | Large


view : Options msg -> List (Html.Html msg) -> Html.Html msg
view options children =
  let
    variant =
      case options.variant of
        Default -> "Padding--default"
        Small -> "Padding--small"
        Large -> "Padding--large"
  in
    div
      (List.append
        [ class "Padding"
        , class variant ]
        options.attributes)
      children
