{--------------------------------------------------------------------------------------------------
                                Interactive Simply-Typed \-Calculus                                
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

{----------------------------------------------------------------------}
{-- Module Imports                                                    -}
{----------------------------------------------------------------------}

import Prelude hiding (pred, succ)
import Control.Applicative ((<$>))
import Control.Monad.Error hiding (fix)
import Control.Monad.State hiding (fix)
import Data.Function (on)
import System.Environment (getArgs)
import System.IO
import Text.Printf (printf)

import qualified Data.Map as M
import qualified Data.Set as S
    
import FreeVars
import Reductible 
import AST
import Lexer
import Parser
import Kinds
import Types
import Inline
import KindCheck
import TypeCheck
import Interpreter

{----------------------------------------------------------------------}
{-- Global Environment                                                -}
{----------------------------------------------------------------------}

checkKindSignature :: String -> Kind -> Maybe Kind -> Env ()
checkKindSignature _ k Nothing  = return ()
checkKindSignature n k (Just s) = do
    env <- get
    case compareKinds (kindEnv env) k s of
        (Left err)    -> error err 
        (Right False) -> error $
            "Kind of `" ++ n ++ "' does not match kind signature:\n\t" ++ show k
        (Right True)  -> return ()

checkTypeSignature :: String -> Type -> Maybe Type -> Env ()
checkTypeSignature _ t Nothing  = return ()
checkTypeSignature n t (Just s) = do
    env <- get
    let 
        r = do t' <- inlineTypes env t
               s' <- inlineTypes env s
               return (nf t',nf s')
    liftIO $ print r
    case compareTypes env t s of
        (Left err)    -> error err 
        (Right False) -> error $
            "Type of `" ++ n ++ "' is:\n\t" ++ show t ++ "\nbut does not match type signature:\n\t" ++ show s
        (Right True)  -> return ()

addGlobalType :: String -> Type -> Kind -> Maybe Kind -> Env ()
addGlobalType n t k Nothing = do
    env <- get
    put $ env { typeEnv = M.insert n (GlDef t k) (typeEnv env) }
addGlobalType n t _ (Just k) = do
    env <- get
    put $ env { typeEnv = M.insert n (GlDef t k) (typeEnv env) }

addGlobalValue :: String -> Expr -> Type -> Maybe Type -> Env ()
addGlobalValue n e t Nothing = do
    env <- get
    put $ env { valEnv = M.insert n (GlDef e t) (valEnv env) }
addGlobalValue n e _ (Just t) = do
    env <- get
    put $ env { valEnv = M.insert n (GlDef e t) (valEnv env) }

-- | Adds a global declaration to the interpreter environment
addDef :: Definition -> Env ()
addDef (KindDec n k) = do
    env <- get 
    case inlineKinds (kindEnv env) k of
        (Left err) -> error err
        (Right k') -> if fvs k' /= S.empty 
                      then error "free kind variable in declaration"
                      else put $ env { kindEnv = M.insert n k' (kindEnv env) }
addDef (TypeDec n mk t) = do
    env <- get
    case inlineTypes env t of
        (Left err) -> error err
        (Right t') -> case kindcheck (mkKindEnv env) t' of
            (Left err) -> error err
            (Right k)  -> do 
                checkKindSignature n k mk
                addGlobalType n t k mk 
addDef (Def n mt e) = do
    env <- get
    case inlineExprs env e of
        (Left err) -> error err
        (Right e') -> case infer e' (initialTyEnv env) of
            (Left m)  -> error m
            (Right t) -> do
                checkTypeSignature n t mt 
                addGlobalValue n e' t mt 
                

{-lookupType :: String -> Env ()
lookupType n = do
    s <- get
    liftIO $ case lookup n (initialTyEnv s) of
        (Just t) -> putStrLn $ n ++ " : " ++ show t
        Nothing  -> putStrLn $ n ++ " is undefined!"-}

lookupFreeVars :: String -> Env ()
lookupFreeVars n = do
    s <- get
    liftIO $ case M.lookup n (valEnv s) of
        (Just (GlDef e _)) -> putStrLn $ show $ fvs e
        Nothing            -> putStrLn $ n ++ " is undefined!"

loadModule :: String -> Env ()
loadModule m = do 
    xs <- liftIO $ readFile m
    --liftIO $ print $ parseProg $ alexScanTokens xs
    mapM_ addDef $ parseProg $ alexScanTokens xs
    liftIO $ putStrLn $ "Loaded " ++ m

{----------------------------------------------------------------------}
{-- User Interface                                                    -}
{----------------------------------------------------------------------}

help :: [String]
help = [
    " Commands available from the prompt:",
    "   <expr>\t\t\tevaluate expression to HNF",
    "   :! <expr>\t\t\tevaluate expression to BNF",
    "   :c <file>\t\t\tcompile program",
    "   :e <expr>\t\t\tshow evaluation steps",
    "   :f <expr>\t\t\tfind free variables",
    "   :s <expr>\t\t\ttranslate to STG language",
    "   :t <expr>\t\t\tshow type",
    "   :k <type>\t\t\tshow kind",
    "   :q\t\t\t\tquit"]

showHelp :: Env ()
showHelp = liftIO $ mapM_ putStrLn help

prompt :: Env String
prompt = liftIO $ putStr "> " >> getLine

parseInlineType :: String -> Env Type 
parseInlineType xs = do
    env <- get
    return $ parseType $ alexScanTokens xs
    {-case inlineTypes env (parseType $ alexScanTokens xs) of
        (Left err) -> fail err 
        (Right t)  -> return t-}
    
parseInput :: String -> Expr
parseInput = parseExpr . alexScanTokens

inlineInput :: String -> Env Expr
inlineInput xs = do env <- get
                    return {-$ inline env-} $ parseInput xs
    
check :: Expr -> Env () -> Env ()
check expr f = get >>= \env -> case infer expr (initialTyEnv env) of
    (Right t) -> f
    (Left m)  -> liftIO $ putStrLn m
    
explain :: Expr -> Env ()
explain e = do
    env <- get
    case eval env e of
        (Left  m) -> liftIO $ putStrLn m
        (Right r) -> if e == r 
                     then do
                        liftIO $ putStrLn "Done!"
                        return ()
                     else do
                        liftIO $ putStrLn $ "=> " ++ show r
                        explain r

    
run :: String -> Env ()
run (':' : 'q' :       []) = return ()
run (':' : '?' :       xs) = showHelp >> loop
run (':' : 'f' : ' ' : xs) = do 
    liftIO $ print (fvs $ parseInput xs) 
    loop
run (':' : '~' : ' ' : xs) = do
    ty <- parseInlineType xs
    env <- get
    case inlineTypes env ty of
        (Left err)  -> liftIO $ putStrLn err
        (Right ty') -> liftIO $ print $ nf ty'
    loop
run (':' : 't' : ' ' : xs) = do expr <- inlineInput xs
                                env <- get
                                case infer expr (initialTyEnv env) of
                                   (Right t) -> liftIO $ putStrLn $ xs ++ " : " ++ show t
                                   (Left m)  -> liftIO $ putStrLn m
                                loop
run (':' : 'k' : ' ' : xs) = do ty <- parseInlineType xs
                                env <- get 
                                case kindcheck (mkKindEnv env) ty of
                                    (Left err) -> liftIO $ putStrLn err 
                                    (Right k)  -> liftIO $ putStrLn $ xs ++ " : " ++ show k
                                loop
run (':' : '!' : ' ' : xs) = do expr <- inlineInput xs
                                check expr $ do
                                    liftIO $ print $ fix reduceBNF expr
                                loop
run (':' : 'e' : ' ' : xs) = do expr <- inlineInput xs
                                check expr $ do
                                    liftIO $ print expr
                                    explain expr
                                loop
run (':' : 'c' : ' ' : xs) = do ty <- parseInlineType xs
                                liftIO $ print $ nf ty
                                loop
run (':' : 's' : ' ' : xs) = do expr <- inlineInput xs
                                check expr $ do
                                    env <- get
                                    case eval env expr of
                                        (Left m)  -> liftIO $ putStrLn m
                                        (Right r) -> do addDef (Def "it" Nothing r)
                                                        liftIO $ print r
                                loop
run (':' : 'm' : ' ' : xs) = do ys <- liftIO $ do
                                    putStr xs
                                    putStr " ~ "
                                    getLine
                                ty1 <- nf <$> parseInlineType xs
                                liftIO $ putStrLn $ xs ++ " = " ++ show ty1
                                ty2 <- case ys of
                                    (':' : 'v' : ' ' : zs) -> do
                                        expr <- inlineInput zs
                                        env <- get
                                        case infer expr (initialTyEnv env) of
                                            (Right t)  -> do
                                                liftIO $ putStrLn $ zs ++ " : " ++ show t
                                                return t
                                            (Left err) -> fail err
                                    _                -> nf <$> parseInlineType ys
                                liftIO $ print $ ty1 == ty2
                                loop
run (':' :             xs) = do liftIO $ putStrLn $ printf "Unknown command ':%s'" xs
                                loop
run xs                     = do expr <- inlineInput xs
                                check expr $ do
                                    env <- get
                                    case fixM (eval env) expr of
                                        (Left m)  -> liftIO $ putStrLn m
                                        (Right r) -> do 
                                            --addDef (Def "it" r)
                                            liftIO $ print r
                                loop

{-    
    The main UI loop prompts the user to enter a command and then
    interprets that command using the eval function.
-}

loop :: Env ()
loop = do expr <- prompt
          run expr

{-
    Loads all modules that were specified on the command-line and then
    enters the main UI loop.
-}

initialise :: [String] -> Env ()
initialise args = do 
    mapM_ loadModule args 
    loop

{-
    The entry point for our program. It simply gets the command-line
    arguments and then initialises the environment.
-}

main :: IO ()
main = do 
    hSetBuffering stdout NoBuffering
    hSetBuffering stdin LineBuffering
    args <- getArgs
    evalStateT (initialise args) emptyGlEnv

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  