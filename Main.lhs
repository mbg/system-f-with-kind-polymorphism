{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}

>   import Control.Monad.State (StateT,get,modify,liftIO,evalStateT)
>   import System.Environment (getArgs)
    
>   import AST
>   import Lexer
>   import Parser
>   import Types
>   import TypeInference

    {----------------------------------------------------------------------}
    {-- Global Environment                                                -}
    {----------------------------------------------------------------------}
    
>   data GlDef = GlDef {
>       glExpr :: Expr,
>       glType :: Type
>   }
    
    The global enviornment contains a list of all definitions and their
    inferred types.
    
>   type GlEnv = [(Variable, GlDef)]

    We use the global environment as state parameter for an instance of the
    state monad transformer on top of IO.
    
>   type Env = StateT GlEnv IO

    The type-inferrence algorithm expects a type environment rather than a
    global environment so that we need two little helper functions which
    remove the expressions from the environment.
   
>   toTyPair :: (Variable, GlDef) -> (Variable, Type)
>   toTyPair (n, GlDef _ t) = (n,t)
   
>   toTyEnv :: GlEnv -> TyEnv
>   toTyEnv = map toTyPair

>   addDef :: Definition -> Env ()
>   addDef (Def n e) = do modify $ \env -> case infer e (toTyEnv env) of
>                           Nothing  -> error $ "Unable to infer the type of " ++ n
>                           (Just t) -> (n,GlDef e t) : env -- TODO: replace old definitions...

>   lookupType :: String -> Env ()
>   lookupType n = get >>= \s -> liftIO $ case lookup n (toTyEnv s) of
>       (Just t) -> putStrLn $ n ++ " : " ++ show t
>       Nothing  -> putStrLn $ n ++ " is undefined!"

>   lookupFreeVars :: String -> Env ()
>   lookupFreeVars n = get >>= \s -> liftIO $ case lookup n s of
>       (Just (GlDef e _)) -> putStrLn $ show $ fvs e
>       Nothing            -> putStrLn $ n ++ " is undefined!"

>   loadModule :: String -> Env ()
>   loadModule m = do xs <- liftIO $ readFile m
>                     mapM_ addDef $ parseProg $ alexScanTokens xs
>                     liftIO $ putStrLn $ "Loaded " ++ m

    {----------------------------------------------------------------------}
    {-- Evaluation                                                        -}
    {----------------------------------------------------------------------}

>   fix :: (Eq a) => (a -> a) -> a -> a
>   fix f x = if x == x' then x else fix f x' 
>             where x' = f x
    
>   bind :: Expr -> Expr -> Expr
>   bind (Abs n _ e) a = cas e n a
>   bind f           a = error $ "trying to apply " ++ show f ++ " to " ++ show a

>   bindBNF :: Expr -> Expr -> Expr
>   bindBNF (Abs n _ e) a = cas e n a
>   bindBNF f           a = App f a
    
    Performs beta-reduction on an expression.
    
>   reduce :: Expr -> Expr
>   reduce (App f a) = bind (reduce f) a
>   reduce expr      = expr
          
>   reduceBNF :: Expr -> Expr
>   reduceBNF (App f a)   = bindBNF (reduceBNF f) (reduceBNF a)
>   reduceBNF (Abs n t e) = Abs n t (reduceBNF e)
>   reduceBNF expr        = expr
    
>   inline' :: [Variable] -> GlEnv -> Expr -> Expr
>   inline' []       _   e = e
>   inline' (x : xs) env e = case lookup x env of
>       (Just (GlDef e' _)) -> inline' xs env (cas e x e')
>       Nothing             -> error "free variable with no definition"
    
>   inline :: GlEnv -> Expr -> Expr
>   inline env expr = inline' (fvs expr) env expr
    
    {----------------------------------------------------------------------}
    {-- User Interface                                                    -}
    {----------------------------------------------------------------------}

>   help :: [String]
>   help = [
>       " Commands available from the prompt:",
>       "   <expr>\t\t\tevaluate expression to HNF",
>       "   :! <expr>\t\t\tevaluate expression to BNF",
>       "   :f <expr>\t\t\tfind free variables",
>       "   :i <expr>\t\t\treplace free variables/inline",
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
>                       return $ fix (inline env) $ parseInput xs
    
>   check :: Expr -> Env ()
>   check expr = get >>= \env -> case infer expr (toTyEnv env) of
>       (Just t) -> return ()
>       Nothing  -> error "Incorrectly typed expression!"
    
>   eval :: String -> Env ()
>   eval (':' : 'q' :       xs) = return ()
>   eval (':' : '?' :       xs) = showHelp >> loop
>   eval (':' : 'f' : ' ' : xs) = lookupFreeVars xs >> loop
>   eval (':' : 't' : ' ' : xs) = do expr <- inlineInput xs
>                                    env <- get
>                                    case infer expr (toTyEnv env) of
>                                       (Just t) -> liftIO $ putStrLn $ xs ++ " : " ++ show t
>                                       Nothing  -> liftIO $ putStrLn $ "Unable to infer the type of " ++ xs
>                                    loop
>   eval (':' : 'i' : ' ' : xs) = do expr <- inlineInput xs
>                                    env <- get
>                                    check expr
>                                    liftIO $ putStrLn $ show $ fix (inline env) expr
>                                    loop
>   eval (':' : '!' : ' ' : xs) = do expr <- inlineInput xs
>                                    check expr
>                                    liftIO $ print $ fix reduceBNF expr
>                                    loop
>   eval xs                     = do expr <- inlineInput xs
>                                    check expr
>                                    liftIO $ print $ fix reduce expr
>                                    loop

    The main UI loop prompts the user to enter a command and then
    interprets that command using the eval function.

>   loop :: Env ()
>   loop = do expr <- prompt
>             eval expr

    Loads all modules that were specified on the command-line and then
    enters the main UI loop.

>   initialise :: [String] -> Env ()
>   initialise args = do mapM_ loadModule args
>                        loop

    The entry point for our program. It simply gets the command-line
    arguments and then initialises the environment.

>   main :: IO ()
>   main = do args <- getArgs
>             evalStateT (initialise args) []

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  