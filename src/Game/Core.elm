module Game.Core exposing (main)

import Game.Core.Facts as Facts exposing (Fact(..))
import Game.Core.Intents as Intents exposing (Intent(..))
import Game.Core.Ports as Ports
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
    Ports.recv (Intents.decode Intent)


type alias Model =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( {}, send SystemInitialized )


type Msg
    = Fact Fact
    | Intent Intent


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "update" msg of
        Fact fact ->
            ( {}, Cmd.none )

        Intent intent ->
            case intent of
                RootClick ->
                    ( {}, send RootClicked )

                UnknownIntent ->
                    ( {}, Cmd.none )



-- Helpers


send : Fact -> Cmd Msg
send fact =
    Ports.send (Facts.encode fact)
