module Main exposing (..)

import Html exposing (..)
import Http

import Model.LastFm as LastFm

import Tags.Root as Root

import Components.Chart as Chart
import Components.Config as Config
import Components.DataSet as DataSet
import Components.MastHead as MastHead


-- Main
main : Program Never Model Msg
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
  { dataView : DataSet
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
  { dataView = TopArtists
  , dataSort = PlayCount
  , isLoading = False
  , errorText = Nothing }


init : (Model, Cmd Msg)
init =
  ( Model initData initState
  , getAllData )



-- Msg type
type Msg
  = RequestData
  | UpdateData (Result Http.Error LastFm.Data)
  | SwitchDataView



-- update
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  let
    data = model.data
    state = model.state

    updateDataAndState = \newData -> \newState -> Model newData state
    updateState = \newState -> Model data newState
  in
    case msg of
      RequestData ->
        ( updateState
          { state
            | isLoading = True }
        , getAllData )

      UpdateData (Ok newData) ->
        ( updateDataAndState
          newData
          { state
            | isLoading = False
            , errorText = Nothing }
        , Cmd.none )

      UpdateData (Err error) ->
        ( updateDataAndState
          initData
          { state
            | isLoading = False
            , errorText = Just (toString error) }
        , Cmd.none )

      SwitchDataView ->
        ( updateState
          ( case state.dataView of
            TopAlbums -> { state | dataView = TopTracks }
            TopArtists -> { state | dataView = TopAlbums }
            TopTracks -> { state | dataView = TopArtists }
          )
        , Cmd.none )



-- View
view : Model -> Html.Html Msg
view model =
  let
    data = model.data
    state = model.state

    content =
      case state.errorText of
        Just error ->
          errorView error

        Nothing ->
          if state.isLoading then
            loadingView
          else
            dataView model

    dataViewText =
      case state.dataView of
        TopAlbums -> "Top Albums by play count"
        TopArtists -> "Top Artists by play count"
        TopTracks -> "Top Tracks by play count"
  in
    Root.view
      { attributes = [] }
      [ MastHead.view { attributes = [] }
      , Config.view
        { attributes = []
        , viewText = dataViewText
        , viewClick = SwitchDataView
        }
      , content ]


dataView : Model -> Html.Html Msg
dataView model =
  let
    data = model.data
    state = model.state

    getMax = \list ->
      let
        max =
          List.maximum
            (List.map (\item -> item.playcount) list)
      in
        case max of
          Nothing -> 0
          Just num -> num

    max =
      case state.dataView of
        TopAlbums -> getMax data.albums
        TopArtists -> getMax data.artists
        TopTracks -> getMax data.tracks

    children =
      case state.dataView of
        TopAlbums ->
          (List.map
            (\album ->
              Chart.itemView
                { title = album.name
                , subTitle = album.artist.name
                , value = album.playcount
                , max = max
                , attributes = [] }
            )
            (List.take (8 * 32) data.albums)
          )

        TopArtists ->
          (List.map
            (\artist ->
              Chart.itemView
                { title = artist.name
                , subTitle = ""
                , value = artist.playcount
                , max = max
                , attributes = [] }
            )
            (List.take (8 * 32) data.artists)
          )

        TopTracks ->
          (List.map
            (\track ->
              Chart.itemView
                { title = track.name
                , subTitle = track.artist.name
                , value = track.playcount
                , max = max
                , attributes = [] }
            )
            (List.take (8 * 32) data.tracks)
          )
  in
    DataSet.view
      { attributes = [] }
      [ Chart.view
        { attributes = [] }
        children
      ]


loadingView : Html.Html Msg
loadingView =
  text "Loading..."


errorView : String -> Html.Html Msg
errorView err =
  text (String.slice 0 1000 err)


---- Get ModalData
getAllData : Cmd Msg
getAllData =
  let
    url =
      "http://localhost:5001/db"
  in
    Http.send UpdateData (Http.get url LastFm.decodeData)

