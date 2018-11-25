module Game.Core.Intents exposing (Intent(..), decode, decodeString, encode)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode


type Intent
    = RootClick
    | UnknownIntent UnknownCause


type UnknownCause
    = DecodeFailed Value
    | UnknownTopic String


decodeBy : String -> Decoder Intent
decodeBy topic =
    case topic of
        "ROOT_CLICK" ->
            Decode.succeed RootClick

        _ ->
            Decode.succeed (UnknownIntent (UnknownTopic topic))


encode : Intent -> Value
encode fact =
    case fact of
        RootClick ->
            Encode.object
                [ ( "topic", Encode.string "ROOT_CLICK" )
                ]

        UnknownIntent (DecodeFailed value) ->
            Encode.object
                [ ( "topic", Encode.string "system/DECODE_FAILED" )
                , ( "meta"
                  , Encode.object
                        [ ( "kind", system )
                        ]
                  )
                , ( "data", value )
                ]

        UnknownIntent (UnknownTopic topic) ->
            Encode.object
                [ ( "topic", Encode.string "system/UNKOWN_INTENT_RECEIVED" )
                , ( "meta"
                  , Encode.object
                        [ ( "kind", system )
                        ]
                  )
                , ( "data", Encode.string topic )
                ]



-- Helpers


decodeString : String -> Intent
decodeString json =
    case Decode.decodeString Decode.value json of
        Ok value ->
            decode identity value

        Err _ ->
            UnknownIntent (DecodeFailed (Encode.object []))


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
            toMsg (UnknownIntent (DecodeFailed value))


system : Value
system =
    Encode.string "system"
