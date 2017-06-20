module Components.MastHead exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Tags.Padding as Padding
import Tags.Wrapper as Wrapper


type alias Options msg =
  { attributes : List (Attribute msg) }


view : Options msg -> Html.Html msg
view options =
  let
    title = \children ->
      h1
        [ class "MastHead__title" ]
        children

    container = \children ->
      Padding.view
        { variant = Padding.Default
        , attributes =
          [ class "MastHead__container" ]
        }
        children

    root = \children ->
      div
        (List.append [ class "MastHead" ] options.attributes)
        [ Wrapper.view
          { variant = Wrapper.Shell
          , attributes = []
          }
          [ container children ]
        ]
  in
    root
      [ title
        [ text "Last.Fm — A Data Viz Thing" ]
      ]

