module Cli.Tests
  (
    main
  , test
  ) where

import Test.Framework
import Test.Framework.Providers.QuickCheck2 (testProperty)
import System.Console.Cli

main ::
  IO ()
main =
  defaultMain [test]

test ::
  Test
test =
    testGroup "Cli"
      [
        testProperty "Right Identity" prop_right_identity
      ]

prop_right_identity ::
  Int
  -> Bool
prop_right_identity n =
  n == n

