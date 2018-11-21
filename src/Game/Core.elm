module Game.Core exposing (main)

import Game.Core.Ports as Ports exposing (Intent(..))
import Json.Decode as Decode exposing (Value)


type alias Flags =
    { id : String
    }


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , subscriptions = subscriptions
        , update = update
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.recv (Ports.decode Intent)


type alias Model =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( {}, Ports.gameInitialized flags )


type Msg
    = Intent Intent


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log ("update " ++ Debug.toString msg) msg of
        Intent intent ->
            case intent of
                RootClick ->
                    ( {}, Ports.rootClicked )

                Unknown ->
                    ( {}, Cmd.none )
