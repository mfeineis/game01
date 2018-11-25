port module Game.Core.Ports exposing (recv, send)

import Json.Decode as Decode exposing (Decoder, Value)
import Json.Encode as Encode


port send : Value -> Cmd msg


port recv : (Value -> msg) -> Sub msg
