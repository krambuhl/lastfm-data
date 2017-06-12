module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
--import Html.Attributes exposing (..)
import Http

import Model.LastFm as LastFm
import Tags.Rhythm as Rhythm
import Tags.Wrapper as Wrapper


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

    albumCount = toString (List.length data.albums)
    artistCount = toString (List.length data.artists)
    trackCount = toString (List.length data.tracks)

    content =
      case state.errorText of
        Just error ->
          [ text (String.slice 0 1000 error) ]

        Nothing ->
          if state.isLoading then
            [ text "Loading..." ]
          else
            [ p [] [ text (albumCount ++ " Albums") ]
            , p [] [ text (artistCount ++ " Artists") ]
            , p [] [ text (trackCount ++ " Tracks") ] ]
  in
    Wrapper.view
      []
      [ Rhythm.view
        [ onClick RequestData ]
        [ Rhythm.view
          [ ]
          content
        , Rhythm.view
          []
          ( List.map
            (\album ->
              p
              []
              [ div [] [ strong [] [text album.name] ]
              , div [] [ text (toString album.playcount) ] ] )
            data.albums)
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

