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
    in
    div
        [ css
            [ Css.fontFamilies [ "Share Tech Mono", Css.monospace.value ]
            , Css.fontWeight <| Css.int 400
            , Css.fontStyle Css.normal
            , Css.boxSizing Css.borderBox
            , Css.Media.withMedia
                [ Css.Media.only Css.Media.screen [ Css.Media.maxWidth <| Css.px breakPoint ] ]
                [ Css.property "padding" "32px max(16px, 4%)"
                , Css.Global.children
                    [ Css.Global.everything
                        [ Css.pseudoClass "not(:last-child)"
                            [ Css.marginBottom <| Css.px 24
                            ]
                        ]
                    ]
                ]
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
                [ Css.minWidth <| Css.px 288
                ]
            ]
            [ section
                [ css [ sectionMargin ] ]
                [ Profile.view [] { username = username }
                ]
            , section
                [ css [ sectionMargin ] ]
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
                          }
                        , { href = appendDomain "https://bsky.app/profile/bsky."
                          , text = "Bluesky"
                          }
                        , { href = "https://mstdn.jp/@nokazzn"
                          , text = "Mastdon (mstdn.jp)"
                          }
                        , { href = appendUsername "https://misskey.io/@"
                          , text = "Misskey (misskey.io)"
                          }
                        , { href = "https://discord.com/users/642284424548843531"
                          , text = "Discord"
                          }
                        , { href = appendUsername "https://keybase.io/"
                          , text = "Keybase"
                          }
                        , { href = appendUsername "https://www.reddit.com/user/"
                          , text = "Reddit"
                          }
                        , { href = appendUsername "https://scrapbox.io/"
                          , text = "Scrapbox"
                          }
                        , { href = appendDomain "https://md."
                          , text = "memo"
                          }
                        , { href = appendUsername "https://github.com/"
                          , text = "GitHub"
                          }
                        , { href = appendUsername "https://gitlab.com/"
                          , text = "GitLab"
                          }
                        , { href = appendUsername "https://stackoverflow.com/users/12688834/"
                          , text = "Stack Overflow"
                          }
                        , { href = appendUsername "https://soundcloud.com/"
                          , text = "SoundCloud"
                          }
                        , { href = appendUsername "https://bandcamp.com/"
                          , text = "Bandcamp"
                          }
                        , { href = "https://open.spotify.com/user/baleariclemon"
                          , text = "Spotify"
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
                             }
                           )
                         , ( "Twitter: "
                           , { href = appendUsername "https://twitter.com/"
                             , text = "@" ++ username
                             }
                           )
                         ]
                        )
                    )
                ]
            ]
        , Card.view aside
            [ css
                []
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
