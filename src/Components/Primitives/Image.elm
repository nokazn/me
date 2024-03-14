module Components.Primitives.Image exposing (view)

import Css
import Html.Styled exposing (Attribute, Html, img)
import Html.Styled.Attributes exposing (alt, css, height, src, width)


type alias Props =
    { src : String
    , alt : String
    , size : Int
    }


view : List (Attribute msg) -> Props -> Html msg
view attrs props =
    img
        ([ css
            [ Css.borderRadius <| Css.px 4
            ]
         , src props.src
         , alt props.alt
         , width props.size
         , height props.size
         ]
            ++ attrs
        )
        []
