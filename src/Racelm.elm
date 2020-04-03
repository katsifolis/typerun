-- A Typeracer Clone in Elm --
module Racelm exposing (main)

import Html exposing (div, h1, h2, img, text, input)
import Random
import Browser
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

type alias Model =
    { raceText  : String 
    , inputText : String
    , textColor : String
    , end       : Bool
    , rng       : Int
    }

type Msg 
    = Check String
    | RandString Int


getText n =
    case n of
        1 -> "Live as if you were to die tomorrow. Learn as if you were to live forever."
        2 -> "That which does not kill us makes us stronger."
        3 -> "We must not allow other people's limited perceptions to define us."
        4 -> "Do what you can, with what you have, where you are."
        5 -> "Be yourself; everyone else is already taken."
        6 -> "Wise men speak because they have something to say; fools because they have to say something."
        7 -> "Strive not to be a success, but rather to be of value."
        8 -> "The difference between ordinary and extraordinary is that little extra."
        9 -> "Too many of us are not living our dreams because we are living our fears."
        _ -> "HEHEHEHE"
 
init : () -> (Model, Cmd Msg)
init _ =
    ( 
        { inputText = "" 
        , raceText = "Type Friend and Enter"
        , textColor = "black"
        , end = False
        , rng = 1
        }
    , Random.generate RandString (Random.int 1 10)
    )

determineColor model = 
    case model.textColor of
        "red" -> 
            h1 [ style "color" "red" ] [ text model.raceText ]
        "green" ->
            h1 [ style "color" "green" ] [ text model.raceText ]
        "blue"  ->
            h1 [ style "color" "blue" ] [ text model.raceText ]
        _  ->
            h1 [ style "color" "blue" ] [ text model.raceText ]

-- VIEW
view model = 
    div []
        [ bigDaddy model ]

-- UPDATE

bigDaddy model =
    div [style "text-align" "center"
        , style "position" "fixed"
        , style "top" "50%" 
        , style "left" "50%" 
        , style "transform" "translate(-50%, -50%)"
        ]
    [ img [ src "assets/eva.gif", width 250, height 200, style "border-radius" "30px"] []
    , determineColor model
    , textBox model
    , endMessage model 
    ]

clearInput : Model -> Bool
clearInput model = 
    let
        word = model.raceText 
            |> String.words
            |> List.head
        input = model.inputText
        sameLength = String.length (Maybe.withDefault "" word)  == String.length input
        
    in
        case word of
            Nothing ->
                False

            Just w ->
                String.contains input w && sameLength

textBox model = 
    input [ value model.inputText
          , autofocus True
          , onInput Check  
          , style "outline" "none"
          , style "text-align" "center"
          , style "border" "none"
          , style "font-size" "28px"
          , style "width" "auto"
          , style "color" "#000"
          , style "margin-top" "50px"
          ]
          []

endMessage model =
    if model.end == True then
        div [] [ h2 [] [ text "Press [SPACE] to continue" ] ]
    else
        div [][]


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    let 
        inputText = model.inputText
        raceText = model.raceText
        end = model.end
        rng = model.rng
    in
        case msg of
            Check s ->
                let 
                    eq = String.startsWith s model.raceText
                in 
                    if s == raceText then 
                        ({ model | textColor = "green", inputText = s, end = True} , Random.generate RandString (Random.int 1 10))
                    else if end == True then
                        ({ model | inputText = "", raceText = (getText rng),  end = False }, Cmd.none)
                    else if clearInput model then
                        let
                            r =
                                raceText
                                |> String.words
                                |> List.tail
                        in
                            case r of
                                Nothing ->
                                    ({model | inputText = ""}, Cmd.none)

                                Just t ->
                                    ({model | inputText = "", raceText = String.join " " t}, Cmd.none)
                    else 
                        ({ model | inputText = s }, Cmd.none)

            RandString n ->
                ({ model | rng = n}, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-------Experimental------
