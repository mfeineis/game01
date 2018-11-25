module Game.Core.Tests exposing (suite)


import Expect
import Game.Core.Facts as Facts exposing (Fact(..))
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


-- Helpers


it =
    test

fail msg =
    Expect.true msg False


pass _ =
    Expect.equal 1 1


theBasicFact fact json =
    describe ("the '" ++ Debug.toString fact ++ "' fact")
        [ it "is the first signal a client should wait for" <| pass
        , it "should decode a well known structure" <|
            \() ->
                Facts.decodeString json
                    |> Expect.equal fact

        , it "should have a matching encoder/decoder pair" <|
            \() ->
                Facts.encode fact
                    |> Facts.decode identity
                    |> Expect.equal fact
        ]


