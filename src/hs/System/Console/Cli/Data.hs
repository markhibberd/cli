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
  Switch [Decl] Description (Update a ())
  | Flag [Decl] Meta Description (Update a String)
  | FlagN Arity [Decl] Meta Description (Update a [String])

data Positional a =
  Positional Meta (Update a String)
  | Positionals Arity Meta (Update a [String])

data Mode a b =
  Mode [Flag a] [Positional a] (a -> b)
  | SubMode [Flag a] [Positional a] (Command a b)

data Command a b =
  Command Name Description [Mode a b]

type Executable a = Command a (IO ())

toUpdate :: Coerse b => Lens a b -> Update a String
toUpdate l a s = fmap (\b -> setL l b a) (coerse s)

toSet :: Lens a Bool -> Update a ()
toSet l a _ = Right $ setL l True a

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

noop :: Update a ()
noop a _ = Right a

switch :: Char -> String -> String -> Lens a Bool -> Flag a
switch s l d u = switch' s l d (toSet u)

-- normalise and include environment decl,
switch' :: Char -> String -> String -> Update a () -> Flag a
switch' s l = Switch [Short s,  Long l, Config l]

flag :: Coerse b => Char -> String -> String -> Lens a b -> Flag a
flag = undefined

flagn :: Coerse b => Char -> String -> String -> Arity -> String -> Lens a [b] -> Flag a
flagn = undefined

arg :: Coerse b => String -> Lens a b -> Positional a
arg = undefined

args :: Coerse b => String -> Arity -> Lens a [b] -> Positional a
args = undefined

mode :: [Flag a] -> [Positional a] -> (a -> b) -> Mode a b
mode = Mode

modeswitch ::Char -> String -> String -> (a -> b) -> Mode a b
modeswitch s l d f = mode [switch' s l d noop] [] f

command :: Name -> Description -> [Mode a b] -> Command a b
command = Command
