module Components.Layouts.Footer exposing (view)

import Css
import Html.Styled exposing (Attribute, Html, footer, small, text)
import Html.Styled.Attributes exposing (css)
import Utils.Colors exposing (colors)


view : List (Attribute msg) -> Html msg
view attrs =
    footer
        (css
            [ Css.color colors.text2
            ]
            :: attrs
        )
        [ small [] [ text "© 2024 nokazn" ]
        ]
