module Game.Core.Intents exposing
    ( Intent(..)
    , decode
    )

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode


type Intent
    = RootClick
    | UnknownIntent


decodeBy : String -> Decoder Intent
decodeBy topic =
    case topic of
        "ROOT_CLICK" ->
            Decode.succeed RootClick

        _ ->
            Decode.succeed UnknownIntent



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
            toMsg UnknownIntent
