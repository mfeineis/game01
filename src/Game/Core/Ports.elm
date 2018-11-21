port module Game.Core.Ports
    exposing
      ( Intent(..)
      , decode
      , gameInitialized
      , recv
      , rootClicked
      )

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode


port send : Value -> Cmd msg


port recv : (Value -> msg) -> Sub msg


type Intent
    = RootClick
    | Unknown


decodeBy : String -> Decoder Intent
decodeBy topic =
    case topic of
        "ROOT_CLICK" ->
            Decode.succeed RootClick

        _ ->
            Decode.succeed Unknown


gameInitialized : { a | id : String } -> Cmd msg
gameInitialized { id } =
    send
        (Encode.object
            [ ( "meta"
              , Encode.object
                    [ ( "id", Encode.string id )
                    ]
              )
            , ( "topic", Encode.string "GAME_INITIALIZED" )
            ]
        )

rootClicked : Cmd msg
rootClicked =
    send
        (Encode.object
            [ ( "topic", Encode.string "ROOT_CLICKED" )
            ]
        )


-- Helpers


decoder : Decoder Intent
decoder =
    Decode.field "topic" Decode.string
        |> Decode.andThen decodeBy


decode : (Intent -> msg) -> Value -> msg
decode toMsg value =
    case Decode.decodeValue decoder value of
        Ok it ->
            toMsg it

        Err _ ->
            toMsg Unknown

