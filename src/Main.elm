module Main exposing (..)

import Browser
import Html exposing (Html, a, button, div, h2, h3, li, main_, p, section, text, ul)
import Html.Attributes exposing (href)



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    String


init : () -> ( Model, Cmd Msg )
init _ =
    ( "", Cmd.none )



-- Update


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    let
        username =
            "nokazn"
    in
    main_ []
        [ button [] [ text "Hello" ]
        , button [] [ text "World" ]
        , p [] [ text model ]
        , section []
            [ h2 [] [ text "Whereabout" ]
            , ul []
                [ li []
                    [ a
                        [ href ("https://twitter.com/" ++ username) ]
                        [ text "Twitter (X)" ]
                    ]
                , li []
                    [ a
                        [ href "https://bsky.app/profile/bsky.nokazn.me"
                        ]
                        [ text "Bluesky" ]
                    ]
                , li []
                    [ a
                        [ href "https://mstdn.jp/@nokazzn"
                        ]
                        [ text "Mastdon (mstdn.jp)" ]
                    ]
                , li []
                    [ a
                        [ href ("https://misskey.io/@" ++ username) ]
                        [ text "Misskey (misskey.io)" ]
                    ]
                , li []
                    [ a
                        [ href "https://discord.com/users/642284424548843531" ]
                        [ text "Discord" ]
                    ]
                , li []
                    [ a
                        [ href ("https://keybase.io/" ++ username) ]
                        [ text "Keybase" ]
                    ]
                , li []
                    [ a
                        [ href ("https://www.reddit.com/user/" ++ username) ]
                        [ text "Reddit" ]
                    ]
                , li []
                    [ a
                        [ href ("https://scrapbox.io/" ++ username) ]
                        [ text "Scrapbox" ]
                    ]
                , li []
                    [ a
                        [ href "https://md.nokazn.me/" ]
                        [ text "メモ帳" ]
                    ]
                , li []
                    [ a
                        [ href ("https://github.com/" ++ username) ]
                        [ text "GitHub" ]
                    ]
                , li []
                    [ a
                        [ href ("https://gitlab.com/" ++ username) ]
                        [ text "GitLab" ]
                    ]
                , li []
                    [ a
                        [ href ("https://stackoverflow.com/users/12688834/" ++ username) ]
                        [ text "Stack Overflow" ]
                    ]
                , li []
                    [ a
                        [ href ("https://soundcloud.com/" ++ username) ]
                        [ text "SoundCloud" ]
                    ]
                , li []
                    [ a
                        [ href ("https://bandcamp.com/" ++ username) ]
                        [ text "Bandcamp" ]
                    ]
                , li []
                    [ a
                        [ href "https://open.spotify.com/user/baleariclemon" ]
                        [ text "Spotify" ]
                    ]
                ]
            ]
        , section []
            [ h2 [] [ text "Contact" ]
            , ul []
                [ li []
                    [ text "Email: "
                    , a
                        [ href "mailto:me@nokazn.me" ]
                        [ text "me@nokazn.me" ]
                    ]
                , li []
                    [ text "Twitter: "
                    , a
                        [ href ("https://twitter.com" ++ username) ]
                        [ text "@nokazn" ]
                    ]
                ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
