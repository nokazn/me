module Main exposing (..)

import Browser
import Html exposing (Html, button, div, p, text)



-- Main


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    String


init : () -> ( Model, Cmd Msg )
init _ =
    ( "", Cmd.none )



-- Update


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update _ model =
    ( model, Cmd.none )



-- View


view : Model -> Html Msg
view model =
    div []
        [ button [] [ text "Hello" ]
        , button [] [ text "World" ]
        , p [] [ text model ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
