module Components.DataSet exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Tags.Padding as Padding
import Tags.Wrapper as Wrapper


type alias Options msg =
  { attributes : List (Attribute msg) }


view : Options msg -> List (Html.Html msg) -> Html.Html msg
view options children =
  div
    (List.append [ class "DataSet" ] options.attributes)
    [ Wrapper.view
      { variant = Wrapper.Shell
      , attributes = []
      }
      [ Padding.view
        { variant = Padding.Large
        , attributes = []
        }
        children
      ]
    ]
