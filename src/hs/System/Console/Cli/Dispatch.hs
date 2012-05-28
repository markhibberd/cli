module System.Console.Cli.Dispatch where


import System.Console.Cli.Data
import System.Environment
import System.Exit


validate :: Either [a] b -> Either a b -> Either [a] b
validate v@(Right _) _ = v
validate (Left errs) v =
  case v of
    Left e -> Left (e : errs)
    Right b -> Right b

validatel :: [Either a b] -> Either [a] b
validatel = foldl validate (Left [])

-- FIX implement help
printhelp :: Command a b -> IO ()
printhelp _ = putStrLn "todo"

printversion :: Command a b -> String -> IO ()
printversion (Command n _ _) v = putStrLn $ n ++ " version " ++ v

-- FIX should be a version that taks conf and environment vars
runpure :: a -> Command a b -> [String] -> Either String b
runpure a (Command _ _ ms) as = runpure' a ms as

runpure' :: a -> [Mode a b] -> [String] -> Either String b
runpure' a ms as =
  case validatel (fmap (\m -> runpure'' a m as) ms) of
    Left [] -> Left "No valid modes to parse."
    Left (e:_) -> Left e
    Right v -> Right v

runpure'' :: a -> Mode a b -> [String] -> Either String b
runpure'' = undefined

run :: a -> Command a b -> IO (Either String b)
run a cmd = fmap (runpure a cmd) getArgs

dispatch :: a -> Executable a -> IO ()
dispatch a exe = run a exe >>= \e ->
  case e of
    Left msg ->
      putStrLn msg >> printhelp exe >> exitFailure
    Right b ->
      b






