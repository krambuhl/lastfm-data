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
  , dataSort : SortFormat }

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
  , dataSort = PlayCount }

init : (Model, Cmd Msg)
init =
  (Model initData initState, Cmd.none)


-- Msg type
type Msg
  = RequestData
  | UpdateData (Result Http.Error LastFm.Image)


-- update
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    RequestData ->
      (model, Cmd.none)

    UpdateData (Ok data) ->
      (Model data model.state, Cmd.none)

    UpdateData (Err _) ->
      (model, Cmd.none)


-- View
view : Model -> Html.Html Msg
view model =
  let
    albumCount =
      List.length model.data.albums

    textContent =
      if albumCount > 0 then
        "Has" ++ (toString albumCount) ++ "Albums"
      else
        "No Albums"
  in
    div
      [ class "Rhythm"
      , onClick RequestData ]
      [ div
        []
        [ text textContent ]
      , button
        []
        [ text "Load Data" ] ]


---- Get ModalData
getAllData : Cmd Msg
getAllData =
  let
    url =
      "http://localhost:5001/db"
  in
    Http.send UpdateData (Http.get url LastFm.decodeImage)

