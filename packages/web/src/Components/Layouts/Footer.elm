module Components.Layouts.Footer exposing (view)

import Css
import Html.Styled exposing (Attribute, Html, footer, small, text)
import Html.Styled.Attributes exposing (css)
import Utils.Colors exposing (colors)


type alias Props =
    {}


view : List (Attribute msg) -> Props -> Html msg
view attrs _ =
    footer
        (css
            [ Css.color colors.text2
            ]
            :: attrs
        )
        [ small [] [ text "© 2024 nokazn" ]
        ]
