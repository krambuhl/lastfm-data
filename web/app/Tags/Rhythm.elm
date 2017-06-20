module Tags.Rhythm exposing (..)

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
        Default -> "Rhythm--default"
        Small -> "Rhythm--small"
        Large -> "Rhythm--large"
  in
    div
      (List.append
        [ class "Rhythm"
        , class variant ]
        options.attributes)
      children
