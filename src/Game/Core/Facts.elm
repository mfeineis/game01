module Game.Core.Facts exposing (Fact(..), decode, decodeString, encode)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode


type Fact
    = RootClicked
    | SystemInitialized
    | UnknownFact UnknownCause


type UnknownCause
    = DecodeFailed Value
    | UnknownTopic String


decodeBy : String -> Decoder Fact
decodeBy topic =
    case topic of
        "ROOT_CLICKED" ->
            Decode.succeed RootClicked

        "system/INITIALIZED" ->
            Decode.succeed SystemInitialized

        _ ->
            Decode.succeed (UnknownFact (UnknownTopic topic))


encode : Fact -> Value
encode fact =
    case fact of
        RootClicked ->
            Encode.object
                [ ( "topic", Encode.string "ROOT_CLICKED" )
                ]

        SystemInitialized ->
            Encode.object
                [ ( "meta"
                  , Encode.object
                        [ ( "kind", system )
                        ]
                  )
                , ( "topic", Encode.string "system/INITIALIZED" )
                ]

        UnknownFact (DecodeFailed value) ->
            Encode.object
                [ ( "topic", Encode.string "system/DECODE_FAILED" )
                , ( "meta"
                  , Encode.object
                        [ ( "kind", system )
                        ]
                  )
                , ( "data", value )
                ]

        UnknownFact (UnknownTopic topic) ->
            Encode.object
                [ ( "topic", Encode.string "system/UNKOWN_FACT_RECEIVED" )
                , ( "meta"
                  , Encode.object
                        [ ( "kind", system )
                        ]
                  )
                , ( "data", Encode.string topic )
                ]



-- Helpers


decoder : Decoder Fact
decoder =
    Decode.field "topic" Decode.string
        |> Decode.andThen decodeBy


decodeString : String -> Fact
decodeString json =
    case Decode.decodeString Decode.value json of
        Ok value ->
            decode identity value

        Err _ ->
            UnknownFact (DecodeFailed (Encode.object []))


decode : (Fact -> msg) -> Value -> msg
decode toMsg value =
    case Decode.decodeValue decoder value of
        Ok it ->
            toMsg it

        Err _ ->
            toMsg (UnknownFact (DecodeFailed value))


system : Value
system =
    Encode.string "system"
