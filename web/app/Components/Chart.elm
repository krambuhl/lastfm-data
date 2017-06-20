module Components.Chart exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Color exposing (..)
import Color.Convert exposing (..)


type alias Options msg =
  { attributes : List (Attribute msg) }


view : Options msg -> List (Html.Html msg) -> Html.Html msg
view options children =
  div
    (List.append [ class "Chart" ] options.attributes)
    children


type alias ItemOptions msg =
  { title : String
  , subTitle : String
  , value : Int
  , max : Int
  , attributes : List (Attribute msg) }


itemView : ItemOptions msg -> Html.Html msg
itemView options =
  let
    ratio =
      (toFloat options.value) / (toFloat options.max)

    color =
      hsl (degrees (0 + (ratio * 180))) 1 0.45

    itemStyle =
      [ ("min-width", toString (ratio * 100) ++ "%")
      ]

    barStyle =
      [ ("transform", "scaleX(" ++ toString ratio ++ ")")
      , ("background-color", colorToCssRgb color)
      ]
  in
    div
      (List.append
        [ class "Chart__item"
        , style itemStyle ]
        options.attributes)
      [ div
        [ class "Chart__value" ]
        [ text (toString options.value)]
      , div
        [ class "Chart__name" ]
        [ span
          []
          [ text options.title ]
        , span
          []
          [ text options.subTitle ]
        ]
      , div
        [ class "Chart__bar"
        , style barStyle ]
        []
      ]
