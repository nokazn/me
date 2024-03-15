module Tests exposing (..)

import Expect
import Test exposing (Test)


suite : Test
suite =
    Test.describe "Some tests"
        [ Test.test "1 + 1 = 2" <|
            \_ ->
                Expect.equal 2 (1 + 1)
        ]
