module Components.Control exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Components.Icon as Icon


type alias Options msg =
  { text : String
  , name : String
  , attributes : List (Attribute msg) }


view : Options msg -> Html.Html msg
view options =
  span
    (List.append [ class "Control" ] options.attributes)
    [ span
      [ ]
      [ text options.text ]
    , Icon.view
      { name = options.name
      , variant = Icon.Default
      , attributes = [] }
    ]
