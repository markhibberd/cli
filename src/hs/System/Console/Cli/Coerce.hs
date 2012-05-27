{-# LANGUAGE FlexibleInstances #-}
module System.Console.Cli.Coerce where

class Coerse a where
  coerse :: String -> Either String a

instance Coerse String where
  coerse = Right

instance Coerse Int where
  coerse s = case reads s of
    [(n, "")] -> Right n
    _ -> Left $ "Invalid integer: " ++ s
