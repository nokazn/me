module Main exposing (main)

import Browser
import Components.Layouts.Footer as Footer
import Components.Primitives.Card as Card
import Components.Primitives.Link as Link
import Components.Profile as Profile
import Css
import Html.Styled exposing (Html, aside, div, h2, h3, li, main_, section, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (css, style)
import Utils.Styles exposing (sectionMargin)



-- Main


main : Program () Model Msg
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


type Msg
    = NoOp


update : Msg -> Model -> Model
update _ model =
    model



-- View


view : Model -> Html Msg
view _ =
    let
        username =
            "nokazn"

        appendUsername str =
            str ++ username

        appendDomain str =
            String.concat [ str, username, ".me" ]

        whereaboutLinks : List Link.Props
        whereaboutLinks =
            [ { href = appendUsername "https://twitter.com/"
              , text = "Twitter (X)"
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
              , text = "メモ帳"
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

        contactLinks =
            let
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
    in
    div
        [ css
            [ Css.fontFamilies [ "Share Tech Mono", Css.monospace.value ]
            , Css.fontWeight <| Css.int 400
            , Css.fontStyle Css.normal
            , Css.boxSizing Css.borderBox
            , Css.padding2 (Css.px 40) (Css.px 24)
            , Css.height <| Css.vh 100
            ]
        , style "display" "grid"
        , style "grid-template-columns" "minmax(auto, 800px) minmax(280px, 320px)"
        , style "grid-template-rows" "1fr auto"
        , style "gap" "16px"
        , style "justify-content" "center"
        ]
        [ main_
            [ css
                [ Css.minWidth <| Css.px 400
                , Css.paddingBottom <| Css.px 24
                ]
            ]
            [ Card.view
                [ css
                    [ Css.height <| Css.pct 100
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
                            liLink props =
                                li [] [ Link.view props ]
                         in
                         List.map liLink whereaboutLinks
                        )
                    ]
                , section
                    []
                    [ h2 [] [ text "Contact" ]
                    , ul []
                        (let
                            liLink ( label, props ) =
                                li []
                                    [ text label
                                    , Link.view props
                                    ]
                         in
                         List.map
                            liLink
                            contactLinks
                        )
                    ]
                ]
            ]
        , aside
            [ css
                [ Css.paddingBottom <| Css.px 24
                ]
            ]
            [ Card.view
                [ css
                    [ Css.height <| Css.pct 100
                    ]
                ]
                [ h2
                    []
                    [ text "Activities" ]
                , h3
                    []
                    [ text "Music" ]
                ]
            ]
        , Footer.view
            [ style "grid-column" "1 / -1"
            ]
            {}
        ]
