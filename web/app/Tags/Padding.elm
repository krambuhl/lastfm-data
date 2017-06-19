module Tags.Padding exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type Variants
  = Default
  | Small
  | Large

variant : Variants -> Attribute msg
variant vtype =
  class <|
    case vtype of
      Default -> "Padding--default"
      Small -> "Padding--small"
      Large -> "Padding--large"


view : List (Attribute msg) -> List (Html.Html msg) -> Html.Html msg
view props children =
  div
    (List.append [ class "Padding" ] props)
    children
