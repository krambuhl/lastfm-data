module Model.LastFm exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)

-- API Types
type alias ArtistInfo =
  { mbid : Maybe String
  , name : String
  , url : String }

type ImageSize
  = Small
  | Medium
  | Large
  | ExtraLarge
  | Mega

type alias Image =
  { size : ImageSize
  , text : Maybe String }

type alias Attributes =
  { rank : Int }

type alias Artist =
  { attributes : Attributes
  , images : List Image
  , mbid : Maybe String
  , name : String
  , playcount : Int
  , url : String }

type alias Album =
  { artist : ArtistInfo
  , attributes : Attributes
  , images : List Image
  , mbid : Maybe String
  , name : String
  , playcount : Int
  , url : String }

type alias Track =
  { artist : ArtistInfo
  , attributes : Attributes
  , duration : Int
  , images : List Image
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
    |> required "images" (list decodeImage)
    |> required "mbid" (nullable string)
    |> required "name" string
    |> required "playcount" int
    |> required "url" string

decodeArtist : Decoder Artist
decodeArtist =
  decode Artist
    |> required "attributes" decodeAttributes
    |> required "images" (list decodeImage)
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
    |> required "images" (list decodeImage)
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

decodeImageSize : String -> Decoder ImageSize
decodeImageSize str =
  case str of
    "small" -> succeed Small
    "medium" -> succeed Medium
    "large" -> succeed Large
    "extralarge" -> succeed ExtraLarge
    "mega" -> succeed Mega
    _ -> succeed Medium

decodeImage : Decoder Image
decodeImage =
  map2 Image
    ((field "size" string |> andThen decodeImageSize))
    (field "text" (nullable string))

decodeAttributes : Decoder Attributes
decodeAttributes =
  decode Attributes
    |> required "rank" int
