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
  | FlagOpt [Decl] Meta Description (Update a (Maybe String))

data Positional a =
  Positional Meta (Update a String)
  | Positionals Arity Meta (Update a [String])

data Mode a b =
  Mode [Flag a] [Positional a] (a -> b)
  | SubMode [Flag a] [Positional a] (Command a b)

data Command a b =
  Command Name Description [Mode a b]

type Executable a = Command a (IO ())

toUpdate :: Lens a b -> Update a b
toUpdate l a b =  Right $  setL l b a

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

-- FIX come up with normalise and include environment
expand :: Char -> String -> [Decl]
expand s l = [Short s, Long l, Config l]

-- FIX sort lens vs update naming convention
-- FIX add partial lens impls
-- FIX this should not be specialised to Bool, enums and alike should be possible
switch :: Char -> String -> String -> Lens a Bool -> Flag a
switch s l d u = switch' s l d (toSet u)

switch' :: Char -> String -> String -> Update a () -> Flag a
switch' s l = Switch (expand s l)

flag :: Coerse b => Char -> String -> String -> String -> Lens a b -> Flag a
flag s l m d u = flag' s l m d (toUpdate u)

flag' :: Coerse b => Char -> String -> String -> String -> Update a b -> Flag a
flag' s l m d u = Flag (expand s l) m d (\a v -> coerse v >>= u a)

flagopt :: Coerse b => Char -> String -> String -> String -> Update a (Maybe b) -> Flag a
flagopt s l m d u = FlagOpt (expand s l) m d (\a v -> undefined)

arg :: Coerse b => String -> Lens a b -> Positional a
arg m u = arg' m (toUpdate u)

arg' :: Coerse b => String -> Update a b -> Positional a
arg' m u =  Positional m (\a v -> coerse v >>= u a)

args :: Coerse b => Arity -> String -> Lens a [b] -> Positional a
args n m u = args' n m (toUpdate u)

args' :: Coerse b => Arity -> String -> Update a [b] -> Positional a
args' n m u = Positionals n m (\a vs -> mapM coerse vs >>= u a)

mode :: [Flag a] -> [Positional a] -> (a -> b) -> Mode a b
mode = Mode

modeswitch ::Char -> String -> String -> b -> Mode a b
modeswitch s l d b = mode [switch' s l d noop] [] (const b)

command :: Name -> Description -> [Mode a b] -> Command a b
command = Command
