module Components.Primitives.Card exposing (Tag, view)

import Css
import Html.Styled exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)
import Utils.Colors exposing (colors)


type alias Tag msg =
    List (Attribute msg) -> List (Html msg) -> Html msg


view : Tag msg -> Tag msg
view tag attrs elements =
    tag
        (css
            [ Css.border3 (Css.px 1) Css.solid colors.border
            , Css.borderRadius <| Css.px 4
            , Css.padding2 (Css.px 24) (Css.px 32)
            , Css.backgroundColor colors.card
            ]
            :: attrs
        )
        elements
