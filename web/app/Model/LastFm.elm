module Model.LastFm exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline as Pipeline


-- API Types
type alias ArtistInfo =
  { mbid : String
  , name : String
  , url : String }

type alias Image =
  { size : String
  , text : String }

type alias Attributes =
  { rank : String }

type alias Artist =
  { attributes : Attributes
  , images : List Image
  , mbid : String
  , name : String
  , playcount : String
  , url : String }

type alias Album =
  { artist : ArtistInfo
  , attributes : Attributes
  , images : List Image
  , mbid : String
  , name : String
  , playcount : String
  , url : String }

type alias Track =
  { artist : ArtistInfo
  , attributes : Attributes
  , duration : String
  , images : List Image
  , mbid : String
  , name : String
  , playcount : String
  , url : String }

type alias Data =
  { albums : List Album
  , artists : List Artist
  , tracks : List Track }


-- decode

decodeData : Decode.Decoder Data
decodeData =
  Decode.map3 Data
    (Decode.field "albums" (Decode.list decodeAlbum))
    (Decode.field "artists" (Decode.list decodeArtist))
    (Decode.field "tracks" (Decode.list decodeTrack))


decodeAlbum : Decode.Decoder Album
decodeAlbum =
  Pipeline.decode Album
    |> Pipeline.required "artist" decodeArtistInfo
    |> Pipeline.required "attributes" decodeAttributes
    |> Pipeline.required "images" (Decode.list decodeImage)
    |> Pipeline.required "mbid" Decode.string
    |> Pipeline.required "name" Decode.string
    |> Pipeline.required "playcount" Decode.string
    |> Pipeline.required "url" Decode.string

decodeArtist : Decode.Decoder Artist
decodeArtist =
  Pipeline.decode Artist
    |> Pipeline.required "attributes" decodeAttributes
    |> Pipeline.required "images" (Decode.list decodeImage)
    |> Pipeline.required "mbid" Decode.string
    |> Pipeline.required "name" Decode.string
    |> Pipeline.required "playcount" Decode.string
    |> Pipeline.required "url" Decode.string


decodeTrack : Decode.Decoder Track
decodeTrack =
  Pipeline.decode Track
    |> Pipeline.required "artist" decodeArtistInfo
    |> Pipeline.required "attributes" decodeAttributes
    |> Pipeline.required "duration" Decode.string
    |> Pipeline.required "images" (Decode.list decodeImage)
    |> Pipeline.required "mbid" Decode.string
    |> Pipeline.required "name" Decode.string
    |> Pipeline.required "playcount" Decode.string
    |> Pipeline.required "url" Decode.string

decodeArtistInfo : Decode.Decoder ArtistInfo
decodeArtistInfo =
  Decode.map3 ArtistInfo
    (Decode.field "mbid" Decode.string)
    (Decode.field "name" Decode.string)
    (Decode.field "url" Decode.string)

decodeImage : Decode.Decoder Image
decodeImage =
  Decode.map2 Image
    (Decode.field "size" Decode.string)
    (Decode.field "text" Decode.string)

decodeAttributes : Decode.Decoder Attributes
decodeAttributes =
  Decode.map Attributes
    (Decode.field "rank" Decode.string)

