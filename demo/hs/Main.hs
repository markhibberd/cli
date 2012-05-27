{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
module Main where

import Data.Lens.Common

import System.Console.Cli

data Arguments = Arguments {
  verbose :: Bool
}

defaults = Arguments False

verboseL = lens verbose $ \v a -> a { verbose = v }

flags = [
   switch 'v' "verbose" "verbose ountput" verboseL
  ]

arguments = [
  ]

demo = command "program" "description" [
--    modeswitch 'h' "help" "display usage" runhelp
--  , modeswitch 'V' "version" "display version" runversion
    mode flags arguments rundemo
  ]

runhelp _ = putStrLn "todo: print help"
runversion _ = putStrLn "todo: print version"
rundemo _ = putStrLn "todo: run demo"

main = dispatch defaults demo




