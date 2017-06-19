module Tags.Wrapper exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type Variants
  = Default
  | Small
  | Large
  | Shell


variant : Variants -> Attribute msg
variant vtype =
  class <|
    case vtype of
      Default -> "Wrapper--default"
      Small -> "Wrapper--small"
      Large -> "Wrapper--large"
      Shell -> "Wrapper--shell"


view : List (Attribute msg) -> List (Html.Html msg) -> Html.Html msg
view props children =
  div
    (List.append [ class "Wrapper" ] props)
    children
