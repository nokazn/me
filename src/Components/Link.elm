module Components.Link exposing (Props, view)

import Css
import Html.Styled exposing (Html, a, text)
import Html.Styled.Attributes exposing (css, href)


type alias Props =
    { href : String
    , text : String
    }


view : Props -> Html msg
view props =
    a
        [ css
            [ Css.color (Css.hex "edd374")
            , Css.visited
                [ Css.color (Css.hex "edab74")
                ]
            ]
        , href props.href
        ]
        [ text props.text
        ]
