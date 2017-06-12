module Tags.Wrapper exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

view : List (Attribute msg) -> List (Html.Html msg) -> Html.Html msg
view props children =
  div
    (List.append [ class "Wrapper" ] props)
    children
