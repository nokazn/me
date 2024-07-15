module Main exposing (main)

import Browser
import Components.Layouts.Footer as Footer
import Components.Primitives.Card as Card
import Components.Primitives.Link as Link
import Components.Profile as Profile
import Css
import Css.Global
import Css.Media
import Html.Styled exposing (Html, aside, div, h2, h3, li, main_, section, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (css, style)
import Utils.Styles exposing (sectionMargin)



-- Main


main : Program () Model ()
main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view >> toUnstyled
        }



-- Model


type alias Model =
    String


init : Model
init =
    ""



-- Update


update : () -> Model -> Model
update _ model =
    model



-- View


view : Model -> Html ()
view _ =
    let
        username : String
        username =
            "nokazn"

        appendUsername : String -> String
        appendUsername str =
            str ++ username

        appendDomain : String -> String
        appendDomain str =
            String.concat [ str, username, ".me" ]

        breakPoint : Float
        breakPoint =
            768

        minDeviceWidth : Float
        minDeviceWidth =
            320

        minSideMargin : Float
        minSideMargin =
            16

        minCardWidth : Float
        minCardWidth =
            minDeviceWidth - minSideMargin * 2
    in
    div
        [ css
            [ Css.fontFamilies [ "Share Tech Mono", Css.monospace.value ]
            , Css.fontWeight <| Css.int 400
            , Css.fontStyle Css.normal
            , Css.boxSizing Css.borderBox

            -- SP
            , Css.Media.withMedia
                [ Css.Media.only Css.Media.screen [ Css.Media.maxWidth <| Css.px breakPoint ] ]
                [ Css.property "padding" ("32px max(" ++ String.fromFloat minSideMargin ++ "px, 4%)")
                , Css.Global.children
                    [ Css.Global.everything
                        [ Css.pseudoClass "not(:last-child)"
                            [ Css.marginBottom <| Css.px 24
                            ]
                        ]
                    ]
                ]

            -- PC
            , Css.Media.withMedia
                [ Css.Media.only Css.Media.screen [ Css.Media.minWidth <| Css.px (breakPoint + 1) ] ]
                [ Css.property "display" "grid"
                , Css.property "justify-content" "center"
                , Css.property "grid-template-columns" "minmax(auto, 640px) minmax(240px, 320px)"
                , Css.property "gap" "max(24px, 2%)"
                , Css.property "padding" "40px max(40px, 2%)"
                ]
            ]
        ]
        [ Card.view main_
            [ css
                [ Css.minWidth <| Css.px minCardWidth
                , Css.Global.children
                    [ Css.Global.everything
                        [ sectionMargin
                        ]
                    ]
                ]
            ]
            [ section
                []
                [ Profile.view [] { username = username }
                ]
            , section
                []
                [ h2 [] [ text "Whereabout" ]
                , ul []
                    (let
                        liLink : Link.Props -> Html msg
                        liLink props =
                            li [] [ Link.view props ]
                     in
                     List.map liLink
                        [ { href = appendUsername "https://twitter.com/"
                          , text = "Twitter"
                          , target = Just "_blank"
                          }
                        , { href = appendDomain "https://bsky.app/profile/bsky."
                          , text = "Bluesky"
                          , target = Just "_blank"
                          }
                        , { href = "https://mstdn.jp/@nokazzn"
                          , text = "Mastdon (mstdn.jp)"
                          , target = Just "_blank"
                          }
                        , { href = appendUsername "https://misskey.io/@"
                          , text = "Misskey (misskey.io)"
                          , target = Just "_blank"
                          }
                        , { href = "https://discord.com/users/642284424548843531"
                          , text = "Discord"
                          , target = Just "_blank"
                          }
                        , { href = appendUsername "https://keybase.io/"
                          , text = "Keybase"
                          , target = Just "_blank"
                          }
                        , { href = appendUsername "https://www.reddit.com/user/"
                          , text = "Reddit"
                          , target = Just "_blank"
                          }
                        , { href = appendUsername "https://scrapbox.io/"
                          , text = "Scrapbox"
                          , target = Just "_blank"
                          }
                        , { href = appendDomain "https://md."
                          , text = "memo"
                          , target = Just "_blank"
                          }
                        , { href = appendUsername "https://github.com/"
                          , text = "GitHub"
                          , target = Just "_blank"
                          }
                        , { href = appendUsername "https://gitlab.com/"
                          , text = "GitLab"
                          , target = Just "_blank"
                          }
                        , { href = appendUsername "https://stackoverflow.com/users/12688834/"
                          , text = "Stack Overflow"
                          , target = Just "_blank"
                          }
                        , { href = appendUsername "https://soundcloud.com/"
                          , text = "SoundCloud"
                          , target = Just "_blank"
                          }
                        , { href = appendUsername "https://bandcamp.com/"
                          , text = "Bandcamp"
                          , target = Just "_blank"
                          }
                        , { href = "https://open.spotify.com/user/baleariclemon"
                          , text = "Spotify"
                          , target = Just "_blank"
                          }
                        ]
                    )
                ]
            , section
                []
                [ h2 [] [ text "Contact" ]
                , ul []
                    (let
                        liLink : ( String, Link.Props ) -> Html msg
                        liLink ( label, props ) =
                            li []
                                [ text label
                                , Link.view props
                                ]
                     in
                     List.map
                        liLink
                        (let
                            email : String
                            email =
                                appendDomain "me@"
                         in
                         [ ( "Email: "
                           , { href = "mailto:" ++ email
                             , text = email
                             , target = Just "_blank"
                             }
                           )
                         , ( "Twitter: "
                           , { href = appendUsername "https://twitter.com/"
                             , text = "@" ++ username
                             , target = Just "_blank"
                             }
                           )
                         ]
                        )
                    )
                ]
            ]
        , Card.view aside
            [ css
                [ Css.minWidth <| Css.px minCardWidth
                ]
            ]
            [ h2
                []
                [ text "Activities" ]
            , h3
                []
                [ text "Music" ]
            ]
        , Footer.view
            [ style "grid-column" "1 / -1"
            ]
            {}
        ]
