-- A Typeracer Clone in Elm --
module Racelm exposing (main)

import Html exposing (div, h1, h2, img, text, button, input, p)
import Time
import Browser
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Json.Decode as D

type alias Model =
    { raceText  : String 
    , inputText : String
    , textColor : String
    , end       : Bool
    }

type Msg 
    = Check String

init : Model
init =
    { inputText = "" 
    , raceText = "this is a very difficult task!"
    , textColor = "black"
    , end = False
    }

determineColor model = 
    case model.textColor of
        "red" -> 
            h1 [ style "color" "red", style "border" "3px solid #000" ] [ text model.raceText ]
        "green" ->
            h1 [ style "color" "green", style "border" "3px solid #000" ] [ text model.raceText ]
        "blue"  ->
            h1 [ style "color" "blue",  style "border" "3px solid #000" ] [ text model.raceText ]
        _  ->
            h1 [ style "color" "blue",  style "border" "3px solid #000" ] [ text model.raceText ]

-- VIEW
view model = 
        div []
            [ h1 [ style "text-align" "center" ] 
                 [ text "A type racing game" ]
            , bigDaddy model
            ]

-- UPDATE

bigDaddy model =
    div [style "text-align" "center"
        , style "position" "fixed"
        , style "top" "50%" 
        , style "left" "50%" 
        , style "transform" "translate(-50%, -50%)"
        ]
    [ determineColor model
    , textBox model
    , endMessage model 
    ]


textBox model = 
    input [ value model.inputText
          , autofocus True
          , onInput Check  
          , style "outline" "none"
          , style "text-align" "center"
          , style "border" "none"
          , style "font-size" "28px"
          , style "width" "200px"
          , style "color" "#000"
          , style "margin-top" "50px"
          ]
          []

endMessage model =
    if model.end == True then
        div [] [ h2 [] [ text "Press [SPACE] to continue" ] ]
    else
        div [][]


update : Msg -> Model -> Model
update msg model =
    let 
        inputText = model.inputText
        raceText = model.raceText
        end = model.end
    in
        case msg of
            Check s ->
                let 
                    eq = String.startsWith s model.raceText
                in 
                    if s == raceText then 
                        { model | textColor = "green", end = True} 
                    else if end == True then
                        { model | inputText = "", raceText = "HOHOHO",  end = False }
                    else
                        { model | inputText = s }

main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
