module Tags.Rhythm exposing (..)

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
      Default -> "Rhythm--default"
      Small -> "Rhythm--small"
      Large -> "Rhythm--large"


view : List (Attribute msg) -> List (Html.Html msg) -> Html.Html msg
view props children =
  div
    (List.append
      [ class "Rhythm" ]
      props)
    children
