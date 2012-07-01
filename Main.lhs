{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}

>   import Control.Monad.State
>   import Data.Function (on)
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

>   bind :: Expr -> Expr -> Expr
>   bind (Abs n _ e) a = cas e n a
>   bind f           a = error $ "trying to apply " ++ show f ++ " to " ++ show a
    
    Performs beta-reduction on an expression.
    
>   reduce :: Expr -> Expr
>   reduce (App f a) = bind (reduce f) a
>   reduce expr      = expr

>   fixReduce :: Expr -> Expr
>   fixReduce e | e == e'   = e
>               | otherwise = fixReduce e'
>               where e' = reduce e
    
>   inline' :: [Variable] -> GlEnv -> Expr -> Expr
>   inline' []       _   e = e
>   inline' (x : xs) env e = case lookup x env of
>       (Just (GlDef e' _)) -> inline' xs env (cas e x e')
>       Nothing             -> error "free variable with no definition"
    
>   inline :: GlEnv -> Expr -> Expr
>   inline env expr = inline' (fvs expr) env expr
    
>   fixInline :: GlEnv -> Expr -> Expr
>   fixInline env e | e == e'   = e
>                   | otherwise = fixInline env e'
>                   where e' = inline env e 
    
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
    
>   parseInput :: String -> Expr
>   parseInput = parseExpr . alexScanTokens
    
>   eval :: String -> Env ()
>   eval (':' : 'q' :       xs) = return ()
>   eval (':' : '?' :       xs) = showHelp >> loop
>   eval (':' : 'f' : ' ' : xs) = lookupFreeVars xs >> loop
>   eval (':' : 't' : ' ' : xs) = do env <- get
>                                    case infer (fixInline env $ parseInput xs) (toTyEnv env) of
>                                       (Just t) -> liftIO $ putStrLn $ xs ++ " : " ++ show t
>                                       Nothing  -> liftIO $ putStrLn $ "Unable to infer the type of " ++ xs
>                                    loop
>   eval (':' : 'i' : ' ' : xs) = do env <- get
>                                    liftIO $ putStrLn $ show $ fixInline env $ parseInput xs
>                                    loop
>   eval xs                     = do env <- get
>                                    liftIO $ print $ fixReduce $ fixInline env $ parseInput xs
>                                    loop

>   loop :: Env ()
>   loop = do expr <- liftIO $ putStr "> " >> getLine
>             eval expr

>   initialise :: [String] -> Env ()
>   initialise args = do mapM_ loadModule args
>                        loop

    

>   main :: IO ()
>   main = do args <- getArgs
>             evalStateT (initialise args) []

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  