module Game.Core.Tests exposing (suite)

import Expect
import Game.Core.Facts as Facts exposing (Fact(..))
import Game.Core.Intents as Intents exposing (Intent(..))
import Json.Decode as Decode
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "The published 'Core' API"
        [ facts
        ]


facts : Test
facts =
    describe "Facts"
        [ systemFacts
        , gameFacts
        , gameIntents
        ]


systemFacts : Test
systemFacts =
    describe "The published system facts"
        [ theBasicFact SystemInitialized
            """
{
    "topic": "system/INITIALIZED"
}
              """
        ]


gameFacts : Test
gameFacts =
    describe "The published game facts"
        [ theBasicFact RootClicked
            """
{
    "topic": "ROOT_CLICKED"
}
              """
        ]


gameIntents : Test
gameIntents =
    describe "The published game intents"
        [ theBasicIntent RootClick
            """
{
    "topic": "ROOT_CLICK"
}
              """
        ]



-- Helpers


it =
    test


fail msg =
    Expect.true msg False


pass _ =
    Expect.equal 1 1


theBasicFact fact json =
    describe ("the '" ++ Debug.toString fact ++ "' fact")
        [ it "should decode a well known structure" <|
            \() ->
                Facts.decodeString json
                    |> Expect.equal fact
        , it "should have a matching encoder/decoder pair" <|
            \() ->
                Facts.encode fact
                    |> Facts.decode identity
                    |> Expect.equal fact
        ]


theBasicIntent intent json =
    describe ("the '" ++ Debug.toString intent ++ "' intent")
        [ it "should decode a well known structure" <|
            \() ->
                Intents.decodeString json
                    |> Expect.equal intent
        , it "should have a matching encoder/decoder pair" <|
            \() ->
                Intents.encode intent
                    |> Intents.decode identity
                    |> Expect.equal intent
        ]
