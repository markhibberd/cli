module System.Console.Cli.Dispatch where

import System.Console.Cli.Data

runpure :: a -> Command a b -> Either String b
runpure = undefined

run :: a -> Command a b -> IO (Either String b)
run = undefined

dispatch :: a -> Executable a -> IO ()
dispatch = error "dispatch todo"
