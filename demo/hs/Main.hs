module Main where

import System.Console.Cli

main ::
  IO ()
main =
  putStrLn "todo"



{-

data Arguments = Arguments {
  verbose :: Bool
}

programflags = [
  switch 'v' "verbose" "verbose ountput" verboseL
]

programargs = [
  switch 'v' "verbose" "verbose ountput" verboseL
]

defaultArgs  = Arguments False

main = dispatch defaultArgs $ command "program" "description" [
    modeswitch 'h' "help" "display usage" runhelp
  , modeswitch 'V' "version" "display version" runversion
  , mode programflags progamargs runprogram
  ]
-}

