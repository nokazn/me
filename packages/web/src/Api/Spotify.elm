module Api.Spotify exposing (ActivityState(..), SpotifyActivity, TrackInfo, fetchActivity)

import Http
import Json.Decode as Decode exposing (Decoder)


type alias TrackInfo =
    { name : String
    , artists : List String
    , album : String
    , imageUrl : String
    , url : String
    , playedAt : Maybe String
    }


type alias SpotifyActivity =
    { currentlyPlaying : Maybe TrackInfo
    , recentlyPlayed : List TrackInfo
    }


type ActivityState
    = ActivityLoading
    | ActivityLoaded SpotifyActivity
    | ActivityFailed Http.Error


trackInfoDecoder : Decoder TrackInfo
trackInfoDecoder =
    Decode.map6 TrackInfo
        (Decode.field "name" Decode.string)
        (Decode.field "artists" (Decode.list Decode.string))
        (Decode.field "album" Decode.string)
        (Decode.field "image_url" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.maybe (Decode.field "played_at" Decode.string))


activityDecoder : Decoder SpotifyActivity
activityDecoder =
    Decode.map2 SpotifyActivity
        (Decode.field "currently_playing" (Decode.nullable trackInfoDecoder))
        (Decode.field "recently_played" (Decode.list trackInfoDecoder))


fetchActivity : String -> (Result Http.Error SpotifyActivity -> msg) -> Cmd msg
fetchActivity workerUrl toMsg =
    Http.get
        { url = workerUrl
        , expect = Http.expectJson toMsg activityDecoder
        }
