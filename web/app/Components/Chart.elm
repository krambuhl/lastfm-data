module Components.Chart exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Color exposing (..)
import Color.Convert exposing (..)

view : List (Attribute msg) -> List (Html.Html msg) -> Html.Html msg
view props children =
  div
    (List.append [ class "Chart" ] props)
    children


type alias ItemOptions =
  { name : String
  , value : Int
  , max : Int }


itemView : List (Attribute msg) -> ItemOptions -> Html.Html msg
itemView props options =
  let
    ratio =
      (toFloat options.value) / (toFloat options.max)

    color =
      hsl (degrees (30 + (ratio * 90))) 1 0.45
  in
    div
      (List.append
        [ class "Chart__item"
        , style
          [ ("height", toString (ratio * 100) ++ "%")
          , ("background-color", colorToCssRgb color)
          ]
        ]
        props)
      [ span
        [ class "Chart__name" ]
        [ span
          []
          [ text (toString options.value) ]
        , text options.name
        ]
      ]
