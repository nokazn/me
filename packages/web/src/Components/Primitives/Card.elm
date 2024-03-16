module Components.Primitives.Card exposing (view)

import Css
import Html.Styled exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css)
import Utils.Colors exposing (colors)


view : List (Attribute msg) -> List (Html msg) -> Html msg
view attrs elements =
    div
        (css
            [ Css.border3 (Css.px 1) Css.solid colors.border
            , Css.borderRadius <| Css.px 4
            , Css.padding2 (Css.px 24) (Css.px 32)
            , Css.backgroundColor colors.card
            ]
            :: attrs
        )
        elements
