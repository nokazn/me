module Components.Activities exposing (view)

import Api.Spotify exposing (SpotifyActivity, TrackInfo)
import Components.Primitives.Link as Link
import Css
import Html.Styled exposing (Html, div, img, li, text, ul)
import Html.Styled.Attributes exposing (alt, css, src)
import Utils.Colors exposing (colors)


view : Maybe SpotifyActivity -> Html msg
view maybeActivity =
    case maybeActivity of
        Nothing ->
            div
                [ css [ Css.color colors.text2 ] ]
                [ text "Loading..." ]

        Just activity ->
            div []
                (viewCurrentlyPlaying activity.currentlyPlaying
                    ++ viewRecentlyPlayed activity.recentlyPlayed
                )


viewCurrentlyPlaying : Maybe TrackInfo -> List (Html msg)
viewCurrentlyPlaying maybeTrack =
    case maybeTrack of
        Nothing ->
            []

        Just track ->
            [ div
                [ css
                    [ Css.marginBottom (Css.px 16)
                    ]
                ]
                [ div
                    [ css
                        [ Css.color colors.text2
                        , Css.fontSize (Css.px 12)
                        , Css.marginBottom (Css.px 4)
                        ]
                    ]
                    [ text "Now Playing" ]
                , viewTrackItem track
                ]
            ]


viewRecentlyPlayed : List TrackInfo -> List (Html msg)
viewRecentlyPlayed tracks =
    if List.isEmpty tracks then
        []

    else
        [ ul
            [ css
                [ Css.listStyle Css.none
                , Css.padding Css.zero
                , Css.margin Css.zero
                ]
            ]
            (List.map (\track -> li [ css [ Css.marginBottom (Css.px 8) ] ] [ viewTrackItem track ]) tracks)
        ]


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
