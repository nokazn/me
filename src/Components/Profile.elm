module Components.Profile exposing (view)

import Components.Primitives.Image as Image
import Css
import Html.Styled exposing (Attribute, Html, div, text)
import Html.Styled.Attributes exposing (css, style)
import Utils.Colors exposing (colors)


type alias Props =
    { username : String
    }


view : List (Attribute msg) -> Props -> Html msg
view attrs props =
    div
        ([ css
            [ Css.displayFlex
            ]
         , style "gap" "32px"
         ]
            ++ attrs
        )
        [ Image.view
            []
            { src = "./src/assets/img/me.jpg"
            , alt = props.username
            , size = 100
            }
        , div
            [ css
                [ Css.color colors.text2
                , Css.fontSize <| Css.rem 1.375
                , Css.displayFlex
                , Css.alignItems Css.end
                ]
            ]
            [ div
                []
                [ text ("@" ++ props.username) ]
            ]
        ]
