module System.Console.Cli where

import Data.Lens.Common

type Update a b = a -> b -> Either String a

type Meta = String

data Decl =
  Short Char | Long String | Config String | Environment String

data Arity =
  Fixed Int
  | Range Int Int
  | Variable Int

data Flag a =
  Switch [Decl] (Update a ())
  | Flag [Decl] Meta (Update a String)
  | FlagN Arity [Decl] Meta (Update a [String])

data Positional a =
  Argument Meta (Update a String)
  | Arguments Arity Meta (Update a [String])

data Mode a b =
  Mode [Flag a] [Positional a] (a -> b)
  | SubMode [Flag a] [Positional a] (Command a b)

data Command a b =
  Command String (Maybe String) [Mode a b]

type Executable a = Command a (IO ())

switch :: Char -> String -> String -> Lens a String -> Flag a
switch = undefined

flag :: Char -> String -> String -> Lens a String -> Flag a
flag = undefined

positional :: String -> Lens a String -> Positional a
positional = undefined

positional0' :: String -> Lens a [String] -> Positional a
positional0' = undefined

positional1' :: String -> Lens a [String] -> Positional a
positional1' = undefined

positionalN :: Int -> String -> Lens a [String] -> Positional a
positionalN = undefined

runpure :: a -> Command a b -> Either String b
runpure = undefined

run :: a -> Command a b -> IO (Either String b)
run = undefined

dispatch :: a -> Executable a -> IO ()
dispatch = undefined


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

