module Tags.Wrapper exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Options msg =
  { variant : Variants
  , attributes : List (Attribute msg) }


type Variants
  = Default
  | Small
  | Large
  | Shell


view : Options msg -> List (Html.Html msg) -> Html.Html msg
view options children =
  let
    variant =
      case options.variant of
        Default -> "Wrapper--default"
        Small -> "Wrapper--small"
        Large -> "Wrapper--large"
        Shell -> "Wrapper--shell"
  in
    div
      (List.append
        [ class "Wrapper"
        , class variant ]
        options.attributes)
      children
