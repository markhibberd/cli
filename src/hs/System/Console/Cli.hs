module System.Console.Cli where

type Update a b = a -> b -> Either String a

type Meta = String

data Decl =
  Short Char | Long String | Config String | Environment String

data Flag a =
  Switch [Decl] (Update a ())
  | FlagOne [Decl] Meta (Update a String)
  | FlagZeroPlus [Decl] Meta (Update a [String])
  | FlagOnePlus [Decl] Meta (Update a [String])
  | FlagN Int [Decl] Meta (Update a [String])
  | FlagNM Int Int [Decl] (Update a [String])

data Positional a =
  PositionalOne Meta (Update a String)
  | PositionalZeroPlus Meta (Update a [String])
  | PositionalOnePlus Meta (Update a [String])
  | PositionalN Int Meta (Update a [String])

data Mode a b =
  Mode [Flag a] [Positional a] (a -> b)
  | SubMode [Flag a] [Positional a] (Command a b)

data Command a b =
  Command String (Maybe String) [Mode a b]

type Executable a = Command a (IO ())

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

programflags = flags [
  switch 'v' "verbose" "verbose ountput" verboseL
]

programargs = flags [
  switch 'v' "verbose" "verbose ountput" verboseL
]

defaultArgs  = Arguments False

main = dispatch defaultArgs $ command "program" "description" [
    modeswitch 'h' "help" "display usage" runhelp
  , modeswitch 'V' "version" "display version" runversion
  , mode programflags progamargs runprogram
  ]
-}

