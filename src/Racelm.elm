-- A Typeracer Clone in Elm --
module Racelm exposing (main)

import Html exposing (div, h1, img, text, button, input)
import Browser
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode as D

                                                                                                -------------------------------------------------
                                                                                                -- This is the text that you should write from --
                                                                                                -------------------------------------------------
type alias Record =
        { quote : String
        , from : String
        }

type alias Model =
        { content : String 
        }

type Msg 
        = Echo String

type Game
        = Character
        | Finished
        | Initiating

init : Model
init =
        { content = "" 
        }

-- VIEW
view model = 
        div [style "text-align" "center"] 
        [ h1 [style "color" "violet"
             ] 
             [ text "Hello there"
             ]
        , input [ placeholder "Text to write", onInput Echo ] []
        , div [ style "margin-top" "20px"
              , style "font-size" "32px"
              ] 
              [ text model.content 
              ]
        ]

-- UPDATE

update : Msg -> Model -> Model
update msg model =
        case msg of
                Echo cont ->
                        { model | content = cont }


-- MAIN

main =
        Browser.sandbox
                { init = init
                , view = view
                , update = update
                }

