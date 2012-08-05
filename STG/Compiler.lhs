{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

This module contains the functions required to compile a STG program into LLVM byte code.

> module STG.Compiler (compileSTG) where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
    
>   import Control.Monad.State
    
>   import LLVM.Core
>   import LLVM.Types
>   import LLVM.Structs
>   import LLVM.Builder

>   import STG.AST
>   import STG.CompilerUtil

    {----------------------------------------------------------------------}
    {-- Closures                                                          -}
    {----------------------------------------------------------------------}

    We need to initially declare all functions so that we can use LLVM's
    ValueRefs in the static reference tables.
    
>   class CodeGenerating c where
>       declareFunctions :: c -> LLVMModule ()

>   instance CodeGenerating Expr where
>       declareFunctions (Let bs e) = do
>           mapM_ declareFunctions bs
>           declareFunctions e
>       declareFunctions (LetRec bs e) = do
>           mapM_ declareFunctions bs
>           declareFunctions e
>       declareFunctions _ = return ()

>   instance CodeGenerating LambdaF where
>       declareFunctions (L _ _ _ e) = declareFunctions e

>   instance CodeGenerating Binding where
>       declareFunctions (B n lf) = do
>           stgFunction (n ++ "_entry")
>           declareFunctions lf
    
    {----------------------------------------------------------------------}
    {-- Bindings                                                          -}
    {----------------------------------------------------------------------}

    Generates the static reference table for a binding. This consists of
    a structure and a global variable of that structure's type. The SRT
    contains pointers to the closures of all free variables in the \-form
    on the right-hand side of the binding.
    
>   generateSRT :: Binding -> Vars -> LLVMModule ()
>   generateSRT (B n lf) vs = do
>       t  <- llvmInt32Type
>       st <- lift $ llvmMakeNamedStruct (n ++ "_srt_struct")
>       lift $ llvmSetStructBody st (replicate (length vs) t) True
>       g  <- llvmAddGlobal (n ++ "_srt") st
>       llvmSetLinkage g InternalLinkage
>       llvmSetGlobalConstant g True
>       -- TODO: add pointers to FV closures

>   generateStaticClosure :: Binding -> LLVMModule ()
>   generateStaticClosure (B n lf) = do
>       t  <- llvmInt32Type
>       st <- lift $ llvmMakeNamedStruct (n ++ "_closure_struct")
>       lift $ llvmSetStructBody st [t,t,t,t] True
>       g  <- llvmAddGlobal (n ++ "_closure") st
>       llvmSetLinkage g InternalLinkage
>       f  <- llvmGetNamedFunction (n ++ "_entry")
>       return ()

    Compiles a STG binding into LLVM bytecode.
    
>   compileBinding :: Binding -> LLVMModule ()
>   compileBinding b = do
>       generateSRT b (freeVarsList b)
>       generateStaticClosure b

    {----------------------------------------------------------------------}
    {-- External Interface                                                -}
    {----------------------------------------------------------------------}
    
    Compiles a STG program into LLVM bytecode.
    
>   compileSTG :: Program -> LLVMModule ()
>   compileSTG (P bs) = do
>       mapM_ declareFunctions bs
>       mapM_ compileBinding bs
    
{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}          
