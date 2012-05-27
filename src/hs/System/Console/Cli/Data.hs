module System.Console.Cli.Data where

import Data.Lens.Common

import System.Console.Cli.Coerce


type Update a b = a -> b -> Either String a

type Name = String
type Description = String
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
  Positional Meta (Update a String)
  | Positionals Arity Meta (Update a [String])

data Mode a b =
  Mode [Flag a] [Positional a] (a -> b)
  | SubMode [Flag a] [Positional a] (Command a b)

data Command a b =
  Command Name Description [Mode a b]

type Executable a = Command a (IO ())

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

mode :: [Flag a] -> [Positional a] -> (a -> b) -> Mode a b
mode = undefined

command :: Name -> Description -> [Mode a b] -> Command a b
command = Command
