module Main exposing (main)

import Browser
import Components.Link
import Css
import Html.Styled exposing (Html, div, h2, li, main_, section, text, toUnstyled, ul)
import Html.Styled.Attributes exposing (css)



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

        whereaboutLinks : List Components.Link.Props
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
    main_
        [ css
            [ Css.fontFamilies [ "Share Tech Mono", Css.monospace.value ]
            , Css.fontWeight (Css.int 400)
            , Css.fontStyle Css.normal
            ]
        ]
        [ section []
            [ h2 [] [ text "Whereabout" ]
            , ul []
                (let
                    liLink props =
                        li [] [ Components.Link.view props ]
                 in
                 List.map liLink whereaboutLinks
                )
            ]
        , section []
            [ h2 [] [ text "Contact" ]
            , ul []
                (let
                    liLink ( label, props ) =
                        li []
                            [ text label
                            , Components.Link.view props
                            ]
                 in
                 List.map
                    liLink
                    contactLinks
                )
            ]
        ]
