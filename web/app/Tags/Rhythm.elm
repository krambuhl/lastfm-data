module Tags.Rhythm exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

view : List (Attribute msg) -> List (Html.Html msg) -> Html.Html msg
view props children =
  div
    (List.append [ class "Rhythm" ] props)
    children
