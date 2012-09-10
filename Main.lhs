{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}

>   import Prelude hiding (pred, succ)
>   import Control.Monad.Error hiding (fix)
>   import Control.Monad.State hiding (fix)
>   import Data.Function (on)
>   import System.Environment (getArgs)
>   import System.IO
>   import Text.Printf (printf)
    
>   import AST
>   import Lexer
>   import Parser
>   import Types
>   import TypeInference
>   import Interpreter

    {----------------------------------------------------------------------}
    {-- Global Environment                                                -}
    {----------------------------------------------------------------------}

>   foo :: Eq a => (a,b) -> (a,b) -> Bool
>   foo = (/=) `on` fst

>   update :: Eq a => (a,b) -> [(a,b)] -> [(a,b)]
>   update x = (:) x . filter (foo x)

>   addDef :: Definition -> Env ()
>   addDef (Def n e) = do
>       env <- get
>       case infer e (toTyEnv env) of
>           (Left m)  -> error m
>           (Right t) -> put $ update (n, GlDef e t) env 

>   lookupType :: String -> Env ()
>   lookupType n = get >>= \s -> liftIO $ case lookup n (toTyEnv s) of
>       (Just t) -> putStrLn $ n ++ " : " ++ show t
>       Nothing  -> putStrLn $ n ++ " is undefined!"

>   lookupFreeVars :: String -> Env ()
>   lookupFreeVars n = get >>= \s -> liftIO $ case lookup n s of
>       (Just (GlDef e _)) -> putStrLn $ show $ fvs e
>       Nothing            -> putStrLn $ n ++ " is undefined!"

>   loadModule :: String ->  Env ()
>   loadModule m = do xs <- liftIO $ readFile m
>                     mapM_ addDef $ parseProg $ alexScanTokens xs
>                     liftIO $ putStrLn $ "Loaded " ++ m

    {----------------------------------------------------------------------}
    {-- User Interface                                                    -}
    {----------------------------------------------------------------------}

>   help :: [String]
>   help = [
>       " Commands available from the prompt:",
>       "   <expr>\t\t\tevaluate expression to HNF",
>       "   :! <expr>\t\t\tevaluate expression to BNF",
>       "   :c <file>\t\t\tcompile program",
>       "   :e <expr>\t\t\tshow evaluation steps",
>       "   :f <expr>\t\t\tfind free variables",
>       "   :s <expr>\t\t\ttranslate to STG language",
>       "   :t <expr>\t\t\tshow type",
>       "   :q\t\t\t\tquit"]

>   showHelp :: Env ()
>   showHelp = liftIO $ mapM_ putStrLn help

>   prompt :: Env String
>   prompt = liftIO $ putStr "> " >> getLine
    
>   parseInput :: String -> Expr
>   parseInput = parseExpr . alexScanTokens

>   inlineInput :: String -> Env Expr
>   inlineInput xs = do env <- get
>                       return {-$ inline env-} $ parseInput xs
    
>   check :: Expr -> Env () -> Env ()
>   check expr f = get >>= \env -> case infer expr (toTyEnv env) of
>       (Right t) -> f
>       (Left m)  -> liftIO $ putStrLn m
    
>   explain :: Expr -> Env ()
>   explain e = do
>       env <- get
>       case eval env e of
>           (Left  m) -> liftIO $ putStrLn m
>           (Right r) -> if e == r 
>                        then return ()
>                        else do
>                           liftIO $ putStrLn $ "=> " ++ show r
>                           explain r
    
>   compile :: String -> Env ()
>   compile fn = do return ()

    
>   run :: String -> Env ()
>   run (':' : 'q' :       []) = return ()
>   run (':' : '?' :       xs) = showHelp >> loop
>   run (':' : 'f' : ' ' : xs) = do liftIO $ print (fvs $ parseInput xs) 
>                                   loop
>   run (':' : 't' : ' ' : xs) = do expr <- inlineInput xs
>                                   env <- get
>                                   case infer expr (toTyEnv env) of
>                                      (Right t) -> liftIO $ putStrLn $ xs ++ " : " ++ show t
>                                      (Left m)  -> liftIO $ putStrLn m
>                                   loop
>   run (':' : '!' : ' ' : xs) = do expr <- inlineInput xs
>                                   check expr $ do
>                                       liftIO $ print $ fix reduceBNF expr
>                                   loop
>   run (':' : 'e' : ' ' : xs) = do expr <- inlineInput xs
>                                   check expr $ do
>                                       liftIO $ print expr
>                                   explain expr
>                                   loop
>   run (':' : 'c' : ' ' : xs) = do compile xs
>                                   loop
>   run (':' : 's' : ' ' : xs) = do expr <- inlineInput xs
>                                   check expr $ do
>                                       env <- get
>                                       case eval env expr of
>                                           (Left m)  -> liftIO $ putStrLn m
>                                           (Right r) -> do addDef (Def "it" r)
>                                                           liftIO $ print r
>                                   loop
>   run (':' :             xs) = do liftIO $ putStrLn $ printf "Unknown command ':%s'" xs
>                                   loop
>   run xs                     = do expr <- inlineInput xs
>                                   check expr $ do
>                                       env <- get
>                                       case fixM (eval env) expr of
>                                           (Left m)  -> liftIO $ putStrLn m
>                                           (Right r) -> do addDef (Def "it" r)
>                                                           liftIO $ print r
>                                   loop

    The main UI loop prompts the user to enter a command and then
    interprets that command using the eval function.

>   loop :: Env ()
>   loop = do expr <- prompt
>             run expr

    Loads all modules that were specified on the command-line and then
    enters the main UI loop.

>   initialise :: [String] -> Env ()
>   initialise args = do mapM_ loadModule args 
>                        loop

    The entry point for our program. It simply gets the command-line
    arguments and then initialises the environment.

>   main :: IO ()
>   main = do hSetBuffering stdout NoBuffering
>             args <- getArgs
>             evalStateT (initialise args) []

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  