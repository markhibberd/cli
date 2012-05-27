{-# LANGUAGE FlexibleInstances #-}
module System.Console.Cli.Coerce where

class Coerse a where
  coerse :: String -> Either String a

instance Coerse String where
  coerse = Right

instance Coerse Int where
  coerse = undefined

instance Coerse Bool where
  coerse = undefined
