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
    modeswitch 'h' "help" "display usage" (printhelp demo)
  , modeswitch 'V' "version" "display version" (printversion demo "0.0.1")
  , mode flags arguments rundemo
  ]

rundemo _ = putStrLn "todo: run demo"

main = dispatch defaults demo
