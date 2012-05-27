module System.Console.Cli.Dispatch where


import System.Console.Cli.Data
import System.Environment
import System.Exit


-- FIX implement help
printhelp :: Command a b -> IO ()
printhelp _ = putStrLn "todo"

printversion :: Command a b -> String -> IO ()
printversion (Command n _ _) v = putStrLn $ n ++ " version " ++ v

-- FIX implement without environment / conf reading
runpure :: a -> Command a b -> [String] -> Either String b
runpure = undefined

-- FIX implement environment / conf reading, until then IO is not used, serving as a placeholder
run :: a -> Command a b -> IO (Either String b)
run a cmd = fmap (runpure a cmd) getArgs

dispatch :: a -> Executable a -> IO ()
dispatch a exe = run a exe >>= \e ->
  case e of
    Left msg ->
      putStrLn msg >> printhelp exe >> exitFailure
    Right b ->
      b






