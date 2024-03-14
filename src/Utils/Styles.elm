module Utils.Styles exposing (..)

import Css


sectionMargin : Css.Style
sectionMargin =
    Css.batch
        [ Css.marginBottom (Css.px 48)
        ]
