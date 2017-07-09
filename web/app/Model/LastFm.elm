module Model.LastFm exposing (..)

import Dict exposing (..)
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)

-- API Types
type alias ArtistInfo =
  { mbid : Maybe String
  , name : String
  , url : String }

type alias Artist =
  { rank : Int
  , images : Dict String String
  , mbid : Maybe String
  , name : String
  , playcount : Int
  , url : String }

type alias Album =
  { rank : Int
  , artist : ArtistInfo
  , images : Dict String String
  , mbid : Maybe String
  , name : String
  , playcount : Int
  , url : String }

type alias Track =
  { rank : Int
  , artist : ArtistInfo
  , duration : Int
  , images : Dict String String
  , mbid : Maybe String
  , name : String
  , playcount : Int
  , url : String }

type alias Data =
  { albums : List Album
  , artists : List Artist
  , tracks : List Track }


-- decode

decodeData : Decoder Data
decodeData =
  decode Data
    |> required "albums" (list decodeAlbum)
    |> required "artists" (list decodeArtist)
    |> required "tracks" (list decodeTrack)

decodeAlbum : Decoder Album
decodeAlbum =
  decode Album
    |> required "artist" decodeArtistInfo
    |> required "attributes" decodeAttributes
    |> required "images" (dict string)
    |> required "mbid" (nullable string)
    |> required "name" string
    |> required "playcount" int
    |> required "url" string

decodeArtist : Decoder Artist
decodeArtist =
  decode Artist
    |> required "attributes" decodeAttributes
    |> required "images" (dict string)
    |> required "mbid" (nullable string)
    |> required "name" string
    |> required "playcount" int
    |> required "url" string

decodeTrack : Decoder Track
decodeTrack =
  decode Track
    |> required "artist" decodeArtistInfo
    |> required "attributes" decodeAttributes
    |> required "duration" int
    |> required "images" (dict string)
    |> required "mbid" (nullable string)
    |> required "name" string
    |> required "playcount" int
    |> required "url" string

decodeArtistInfo : Decoder ArtistInfo
decodeArtistInfo =
  decode ArtistInfo
    |> (required "mbid" (nullable string))
    |> required "name" string
    |> required "url" string

decodeAttributes : Decoder Attributes
decodeAttributes =
  decode Attributes
    |> required "rank" int
