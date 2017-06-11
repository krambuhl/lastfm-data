module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http

import Model.LastFm as LastFm


-- Main
main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = \_ -> Sub.none }

-- Types
type DataSet
  = TopAlbums
  | TopArtists
  | TopTracks

type SortFormat
  = PlayCount
  | TimePlayed

type alias State =
  { dataSet : DataSet
  , dataSort : SortFormat
  , isLoading : Bool
  , errorText : Maybe String }

type alias Model =
  { data : LastFm.Data
  , state : State }


-- Init
initData : LastFm.Data
initData =
  { artists = []
  , albums = []
  , tracks = [] }

initState : State
initState =
  { dataSet = TopAlbums
  , dataSort = PlayCount
  , isLoading = False
  , errorText = Nothing }

init : (Model, Cmd Msg)
init =
  (Model initData initState, Cmd.none)


-- Msg type
type Msg
  = RequestData
  | UpdateData (Result Http.Error LastFm.Data)


-- update
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    data = model.data
    state = model.state
  in
    case msg of
      RequestData ->
        ( Model
          data
          { state
            | isLoading = True }
        , getAllData )

      UpdateData (Ok data) ->
        ( Model
          data
          { state
            | isLoading = False
            , errorText = Nothing }
        , Cmd.none )

      UpdateData (Err error) ->
        ( Model
          data
          { state
            | isLoading = False
            , errorText = Just (toString error) }
        , Cmd.none )


-- View
view : Model -> Html.Html Msg
view model =
  let
    data = model.data
    state = model.state

    albumCount = List.length data.albums
    artistCount = List.length data.artists
    trackCount = List.length data.tracks

    content =
      case state.errorText of
        Just error ->
          [ text (String.slice 0 1000 error) ]

        Nothing ->
          if state.isLoading then
            [ text "Loading..." ]
          else if albumCount > 0 then
            [ p [] [ text ((toString albumCount) ++ " Albums") ]
            , p [] [ text ((toString artistCount) ++ " Artists") ]
            , p [] [ text ((toString trackCount) ++ " Tracks") ] ]
          else
            [text "No Albums"]
  in
    div
      [ class "Wrapper" ]
      [ div
        [ class "Rhythm"
        , onClick RequestData ]
        [ div
          [ class "Rhythm" ]
          content
        , button
          []
          [ text "Load Data" ]
        ]
      ]


---- Get ModalData
getAllData : Cmd Msg
getAllData =
  let
    url =
      "http://localhost:5001/db"
  in
    Http.send UpdateData (Http.get url LastFm.decodeData)

