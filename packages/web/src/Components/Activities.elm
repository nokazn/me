module Components.Activities exposing (view)

import Api.Spotify exposing (ActivityState(..), TrackInfo)
import Components.Primitives.Link as Link
import Css
import Html.Styled exposing (Attribute, Html, div, img, text)
import Html.Styled.Attributes exposing (alt, css, src)
import Http
import Utils.Colors exposing (colors)


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        Http.BadUrl url ->
            "Bad URL: " ++ url

        Http.Timeout ->
            "Timeout"

        Http.NetworkError ->
            "Network error (CORS?)"

        Http.BadStatus code ->
            "HTTP " ++ String.fromInt code

        Http.BadBody body ->
            "Bad body: " ++ body


view : List (Attribute msg) -> ActivityState -> Html msg
view attrs state =
    case state of
        ActivityLoading ->
            div
                (css [ Css.color colors.text2 ] :: attrs)
                [ text "Loading..." ]

        ActivityFailed err ->
            div
                (css [ Css.color colors.text2 ] :: attrs)
                [ text ("Failed: " ++ httpErrorToString err) ]

        ActivityLoaded activity ->
            let
                track : Maybe TrackInfo
                track =
                    case activity.currentlyPlaying of
                        Just t ->
                            Just t

                        Nothing ->
                            List.head activity.recentlyPlayed
            in
            case track of
                Nothing ->
                    div
                        (css [ Css.color colors.text2 ] :: attrs)
                        [ text "No recent tracks." ]

                Just t ->
                    div attrs [ viewTrackItem t ]


viewTrackItem : TrackInfo -> Html msg
viewTrackItem track =
    div
        [ css
            [ Css.displayFlex
            , Css.alignItems Css.center
            , Css.property "gap" "8px"
            ]
        ]
        [ img
            [ src track.imageUrl
            , alt track.album
            , css
                [ Css.width (Css.px 40)
                , Css.height (Css.px 40)
                , Css.borderRadius (Css.px 4)
                , Css.flexShrink Css.zero
                ]
            ]
            []
        , div
            [ css
                [ Css.overflow Css.hidden
                , Css.minWidth Css.zero
                ]
            ]
            [ div
                [ css
                    [ Css.fontSize (Css.px 14)
                    , Css.property "white-space" "nowrap"
                    , Css.overflow Css.hidden
                    , Css.textOverflow Css.ellipsis
                    ]
                ]
                [ Link.view
                    { href = track.url
                    , text = track.name
                    , target = Just "_blank"
                    }
                ]
            , div
                [ css
                    [ Css.fontSize (Css.px 12)
                    , Css.color colors.text2
                    , Css.property "white-space" "nowrap"
                    , Css.overflow Css.hidden
                    , Css.textOverflow Css.ellipsis
                    ]
                ]
                [ text (String.join ", " track.artists) ]
            ]
        ]
