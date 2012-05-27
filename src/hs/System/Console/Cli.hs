{-# LANGUAGE FlexibleInstances #-}
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

type Parser a = String -> Either String a


class Coerse a where
  coerse :: String -> Either String a

instance Coerse String where
  coerse = Right

instance Coerse Int where
  coerse = undefined

instance Coerse Bool where
  coerse = undefined

zeroplus :: Arity
zeroplus = Variable 0

oneplus :: Arity
oneplus = Variable 1

twoplus :: Arity
twoplus = Variable 1

exactly :: Int -> Arity
exactly = Fixed

between :: Int -> Int -> Arity
between = Range


switch :: Coerse b => Char -> String -> String -> Lens a b -> Flag a
switch = undefined

flag :: Coerse b => Char -> String -> String -> Lens a b -> Flag a
flag = undefined

flagn :: Coerse b => Char -> String -> String -> Arity -> String -> Lens a [b] -> Flag a
flagn = undefined

arg :: Coerse b => String -> Lens a b -> Positional a
arg = undefined

args :: Coerse b => String -> Arity -> Lens a [b] -> Positional a
args = undefined

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

