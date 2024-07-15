module Components.Primitives.Link exposing (Props, view)

import Css
import Html.Styled exposing (Html, a, text)
import Html.Styled.Attributes exposing (css, href, target)
import Utils.Colors exposing (colors)


type alias Props =
    { href : String
    , text : String
    , target : Maybe String
    }


view : Props -> Html msg
view props =
    a
        ([ css
            [ Css.color colors.link
            , Css.visited
                [ Css.color colors.linkVisited
                ]
            ]
         , href props.href
         ]
            ++ (case props.target of
                    Just t ->
                        [ target t ]

                    Nothing ->
                        []
               )
        )
        [ text props.text
        ]
