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

type alias Streamable =
  { fulltrack : String
  , text : String }

type alias Attributes =
  { rank : Int }

type alias Artist =
  { attributes : Attributes
  , images : List Image
  , mbid : String
  , name : String
  , playcount : Int
  , streamable : String
  , url : String }

type alias Album =
  { artist : ArtistInfo
  , attributes : Attributes
  , images : List Image
  , mbid : String
  , name : String
  , playcount : Int
  , url : String }

type alias Track =
  { artist : ArtistInfo
  , attributes : Attributes
  , duration : Int
  , images : List Image
  , mbid : String
  , name : String
  , playcount : Int
  , streamable : Streamable
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
  Decode.map7 Album
    (Decode.field "name" Decode.string)
    (Decode.field "playcount" Decode.int)
    (Decode.field "mbid" Decode.string)
    (Decode.field "url" Decode.string)
    (Decode.field "artist" decodeArtistInfo)
    (Decode.field "image" (Decode.list decodeImage))
    (Decode.field "@attr" decodeAttributes)

decodeArtist : Decode.Decoder Artist
decodeArtist =
  Decode.map7 Artist
    (Decode.field "attributes" decodeAttributes)
    (Decode.field "playcount" Decode.int)
    (Decode.field "images" (Decode.list decodeImage))
    (Decode.field "mbid" Decode.string)
    (Decode.field "name" Decode.string)
    (Decode.field "streamable" decodeStreamable)
    (Decode.field "url" Decode.string)


--decodeData =
--  Pipeline.decode Data
--    (Decode.field

decodeTrack : Decode.Decoder Track
decodeTrack =
  Decode.map8 Track
    (Decode.field "artist" decodeArtistInfo)
    (Decode.field "attributes" decodeAttributes)
    (Decode.field "images" (Decode.list decodeImage))
    (Decode.field "mbid" Decode.string)
    (Decode.field "name" Decode.string)
    (Decode.field "playcount" Decode.int)
    (Decode.field "streamable" decodeStreamable)
    (Decode.field "url" Decode.string)

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

decodeStreamable : Decode.Decoder Streamable
decodeStreamable =
  Decode.map2 Streamable
    (Decode.field "fulltrack" Decode.string)
    (Decode.field "text" Decode.string)

decodeAttributes : Decode.Decoder Attributes
decodeAttributes =
  Decode.map Attributes
    (Decode.field "rank" Decode.int)

