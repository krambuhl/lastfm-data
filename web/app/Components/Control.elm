module Components.Control exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Components.Icon as Icon


type alias Options =
  { text : String
  , name : String }


view : List (Attribute msg) -> Options -> Html.Html msg
view props options =
  span
    (List.append [ class "Control" ] props)
    [ span
      [ ]
      [ text options.text ]
    , Icon.view
      []
      { variant = Icon.Default
      , name = options.name }
    ]
