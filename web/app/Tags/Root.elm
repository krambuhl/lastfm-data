module Tags.Root exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


type alias Options msg =
  { attributes : List (Attribute msg) }


view : Options msg -> List (Html.Html msg) -> Html.Html msg
view options children =
  div
    (List.append
      [ class "Root" ]
      options.attributes)
    children
