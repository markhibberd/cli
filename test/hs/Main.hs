module Main where

import qualified Cli.Tests
import Test.Framework

main ::
  IO ()
main = 
  defaultMain tests 

tests ::
  [Test]
tests =
  [
    testGroup "Tests"
      [
        Cli.Tests.test
      ]
  ]

