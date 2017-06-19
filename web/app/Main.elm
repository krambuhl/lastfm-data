module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http

import Model.LastFm as LastFm

import Tags.Padding as Padding
import Tags.Root as Root
import Tags.Wrapper as Wrapper

import Components.Icon as Icon
import Components.Chart as Chart
import Components.Control as Control


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
  , isConfigOpen : Bool
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
  { dataView = TopAlbums
  , dataSort = PlayCount
  , isLoading = False
  , isConfigOpen = False
  , errorText = Nothing }


init : (Model, Cmd Msg)
init =
  ( Model initData initState
  , getAllData )



-- Msg type
type Msg
  = RequestData
  | UpdateData (Result Http.Error LastFm.Data)
  | OpenConfig
  | CloseConfig
  | ToggleConfig
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

      OpenConfig ->
        ( updateState
          { state
            | isConfigOpen = True }
        , Cmd.none )

      CloseConfig ->
        ( updateState
          { state
            | isConfigOpen = False }
        , Cmd.none )

      ToggleConfig ->
        ( updateState
          { state
            | isConfigOpen = not state.isConfigOpen }
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
  in
    Root.view
      []
      [ mastHeadView model
      , content ]


mastHeadView : Model -> Html.Html Msg
mastHeadView model =
  let
    state = model.state

    title = \children ->
      h1
        [ class "MastHead__title" ]
        children

    control =
      span
        [ class "MastHead__control"
        , onClick OpenConfig ]
        [ Control.view []
          { text = "Change View"
          , name = "gear" }
        ]

    config =
      div
        [ class "MastHead__config" ]
        [ configView model ]

    container = \children ->
      Padding.view
        [ Padding.variant Padding.Default
        , class "MastHead__container" ]
        children

    root = \children ->
      div
        [ classList
          [ ("MastHead", True)
          , ("is-config-open", state.isConfigOpen) ]
        ]
        [ Wrapper.view
          [ Wrapper.variant Wrapper.Shell ]
          [ container children
          , config
          ]
        ]
  in
    root
      [ title
        [ text "Last.Fm — A Data Viz Thing" ]
      , control
      ]


configView : Model -> Html.Html Msg
configView model =
  let
    control =
      div
        [ class "Config__control"
        , onClick CloseConfig ]
        [ Icon.view []
          { variant = Icon.Default
          , name = "close" }
        ]

    container = \static ->
      Wrapper.view
        [ Wrapper.variant Wrapper.Shell ]
        [ Padding.view
          [ Padding.variant Padding.Large
          , class "Config__container" ]
          (control :: static)
        ]

    root = \static ->
      div
        [ class "Config" ]
        [ container
          [ div [ class "Config__content" ] static ]
        ]

    dataViewText =
      case model.state.dataView of
        TopAlbums -> "Top Albums by play count"
        TopArtists -> "Top Artists by play count"
        TopTracks -> "Top Tracks by play count"
  in
    root
      [ text "Using "
      , strong [] [ text "Caforna" ]
      , text "’s Last.fm data display "
      , strong
        [ onClick SwitchDataView ]
        [ text dataViewText ]
      ]


dataView : Model -> Html.Html Msg
dataView model =
  let
    state = model.state

    dataView = state.dataView

    container = \children ->
      div
        [ class "DataSet" ]
        [ Wrapper.view
          [ Wrapper.variant Wrapper.Shell ]
          [ div
            [ class "DataSet__container" ]
            children
          ]
        ]

    getMax = \list ->
      let
        max =
          List.maximum
            (List.map
              (\item -> item.playcount)
              list
            )
      in
        case max of
          Just num -> num
          Nothing -> 0

    max =
      case dataView of
        TopAlbums -> getMax model.data.albums
        TopArtists -> getMax model.data.artists
        TopTracks -> getMax model.data.tracks

    count =
      500
      --case dataView of
      --  TopAlbums -> List.length model.data.albums
      --  TopArtists -> List.length model.data.artists
      --  TopTracks -> List.length model.data.tracks

    chartWidth =
      count * 3

    item = \rowData ->
      Chart.itemView []
        { name = rowData.name
        , value = rowData.value
        , max = rowData.max }

    children =
      case dataView of
        TopAlbums ->
          (List.map
            (\album ->
              item
                { name = album.name
                , value = album.playcount
                , max = max }
            )
            (List.take 500 model.data.albums)
          )

        TopArtists ->
          (List.map
            (\artist ->
              item
                { name = artist.name
                , value = artist.playcount
                , max = max }
            )
            (List.take 500 model.data.artists)
          )

        TopTracks ->
          (List.map
            (\track ->
              item
                { name = track.name
                , value = track.playcount
                , max = max }
            )
            (List.take 500 model.data.tracks)
          )

  in
    container
      [ Chart.view
        [ style
          [ ("width", toString chartWidth ++ "em") ]
        ]
        children ]


artistView : LastFm.Artist -> Html.Html Msg
artistView artist =
  div
    [ class "Artist" ]
    [ div [ ] [ strong [ ] [text artist.name] ]
    , div [ ] [ text (toString artist.playcount) ]
    ]


trackView : LastFm.Track -> Html.Html Msg
trackView track =
  div
    [ class "Track" ]
    [ div [ ] [ strong [ ] [text track.name] ]
    , div [ ] [ text (toString track.playcount) ]
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

