module Utils.Colors exposing (..)

import Css


colors :
    { link : Css.Color
    , linkVisited : Css.Color
    , border : Css.Color
    , card : Css.Color
    , text : Css.Color
    , text2 : Css.Color
    }
colors =
    { link = Css.hex "edd374"
    , linkVisited = Css.hex "edab74"
    , border = Css.hex "828685"
    , card = Css.hex "1e1e1e"
    , text = Css.hex "f2f2f2"
    , text2 = Css.hex "c1c1c1"
    }
