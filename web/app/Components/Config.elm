module Components.Config exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Tags.Padding as Padding
import Tags.Wrapper as Wrapper


type alias Options msg =
  { attributes : List (Attribute msg)
  , viewText : String
  , viewClick : msg
  }


view : Options msg -> Html.Html msg
view options =
  let
    container = \static ->
      Wrapper.view
        { variant = Wrapper.Shell
        , attributes = []
        }
        [ Padding.view
          { variant = Padding.Large
          , attributes =
            [ class "Config__container" ]
          }
          static
        ]

    root = \static ->
      div
        (List.append [ class "Config" ] options.attributes)
        [ container
          [ div [ class "Config__content" ] static ]
        ]
  in
    root
      [ text "Using "
      , strong [] [ text "Caforna" ]
      , text "’s Last.fm data, displaying "
      , strong
        [ onClick options.viewClick ]
        [ text options.viewText ]
      ]
