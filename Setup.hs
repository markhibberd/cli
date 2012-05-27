#!/usr/bin/env runhaskell

import Distribution.Simple
import System.Environment

defaultArgs args = args ++ [ "--builddir", "gen/cabal" ]

run args@("configure":_) = defaultMainArgs $ defaultArgs args ++ [ "--user" ]
run args = defaultMainArgs . defaultArgs $ args

main = getArgs >>= \args -> 
  if null args
    then (run [ "configure" ]) >> (run [ "build" ])
    else run args
