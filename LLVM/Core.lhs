{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

This module contains the core functions and types for the LLVM code generator. 

> module LLVM.Core (
>     LLVMContext,
>     LLVMModule,
>     llvmWithContext,
>     llvmWithGlobalContext,
>     llvmWithModule,
>     llvmSetModuleInlineAsm,
>     llvmDumpModule,
>     llvmWriteModuleToFile,
>   llvmDumpValue,
>   llvmSetValueName,
>     llvmSetLinkage,
>     llvmSetVisibility,
>     llvmAddGlobal,
>     llvmSetGlobalConstant,
>     llvmSetInitialiser,
>     llvmAddFunction,
>     llvmGetNamedFunction,
>   llvmAddFunctionAttr,
>   llvmGetParam,
>   llvmAppendBasicBlock,
>   llvmSetCallConv,
>   llvmAddAttribute,
>   llvmSetTailCall,
>     FFI.Visibility(..),
>     FFI.Linkage(..),
>   FFI.CallingConv(..),
>   FFI.Attribute(..),
>     FFI.ValueRef
> )
> where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}

    We use some monad stuff and some FFI functions from the standard 
    libraries.
    
>   import Control.Monad.State
>   import Foreign.C.String (withCString)
>   import Foreign.Marshal.Utils (fromBool)
    
    Additionally, we need the FFI imports of the LLVM core libraries.
    
>   import qualified LLVM.FFI.Core as FFI
    
    {----------------------------------------------------------------------}
    {-- LLVM Context                                                      -}
    {----------------------------------------------------------------------}
    
    A LLVM context is a state monad transformer for the FFI representation
    of a LLVM context on top of the IO monad.
    
>   type LLVMContext = StateT FFI.ContextRef IO
    
    Runs a function in a LLVM context.
    
>   llvmWithContext :: LLVMContext a -> IO a
>   llvmWithContext f = do c <- FFI.llvmCreateContext
>                          r <- evalStateT f c
>                          FFI.llvmDisposeContext c
>                          return r

    Runs a function in the global LLVM context.
    
>   llvmWithGlobalContext :: LLVMContext a -> IO a
>   llvmWithGlobalContext f = do c <- FFI.llvmGetGlobalContext
>                                evalStateT f c
    
    {----------------------------------------------------------------------}
    {-- LLVM Module                                                       -}
    {----------------------------------------------------------------------}
    
    A LLVM module is a state monad transformer for the FFI representation of
    a LLVM module on top of a LLVM context.
    
>   type LLVMModule = StateT FFI.ModuleRef LLVMContext
    
    Runs a function in a LLVM module context.
    
>   llvmWithModule :: String -> LLVMModule () -> LLVMContext ()
>   llvmWithModule n f = do m <- liftIO $ llvmCreateModuleWithName n
>                           evalStateT f m
>                           liftIO $ FFI.llvmDisposeModule m
    
    {----------------------------------------------------------------------}
    {-- Module Functions                                                  -}
    {----------------------------------------------------------------------}
    
    Creates a module with the specified name.
    
>   llvmCreateModuleWithName :: String -> IO FFI.ModuleRef
>   llvmCreateModuleWithName n = withCString n $ 
>       \s -> FFI.llvmCreateModuleWithName s
    
    Adds inline assembly to the current module.
    
>   llvmSetModuleInlineAsm :: String -> LLVMModule ()
>   llvmSetModuleInlineAsm c = get >>= 
>       \m -> liftIO $ withCString c $ 
>       \s -> FFI.llvmSetModuleInlineAsm m s
    
    Dumps the code for the current module to stdout.
    
>   llvmDumpModule :: LLVMModule ()
>   llvmDumpModule = get >>= 
>       \m -> liftIO $ FFI.llvmDumpModule m
    
    Writes the code for the current module to a file.
    
>   llvmWriteModuleToFile :: String -> LLVMModule ()
>   llvmWriteModuleToFile f = get >>= 
>       \m -> liftIO $ withCString f $ 
>       \s -> FFI.llvmWriteModuleToFile m s

>   llvmDumpValue :: FFI.ValueRef -> LLVMContext ()
>   llvmDumpValue v = liftIO $ FFI.llvmDumpValue v

>   llvmSetValueName :: FFI.ValueRef -> String -> LLVMContext ()
>   llvmSetValueName v n = liftIO $ withCString n $
>       \s -> FFI.llvmSetValueName v s

    {----------------------------------------------------------------------}
    {-- LLVM Globals                                                      -}
    {----------------------------------------------------------------------}
    
>   llvmSetLinkage :: FFI.ValueRef -> FFI.Linkage -> LLVMModule ()
>   llvmSetLinkage g l = liftIO $ FFI.llvmSetLinkage g (FFI.fromLinkage l)
    
>   llvmSetVisibility :: FFI.ValueRef -> FFI.Visibility -> LLVMModule ()
>   llvmSetVisibility g v = liftIO $ FFI.llvmSetVisibility g (FFI.fromVisibility v)
    
>   llvmAddGlobal :: String -> FFI.TypeRef -> LLVMModule FFI.ValueRef
>   llvmAddGlobal n t = get >>=
>       \m -> liftIO $ withCString n $
>       \s -> FFI.llvmAddGlobal m t s

>   llvmSetGlobalConstant :: FFI.ValueRef -> Bool -> LLVMModule ()
>   llvmSetGlobalConstant g p = liftIO $ FFI.llvmSetGlobalConstant g (fromBool p)

>   llvmSetInitialiser :: FFI.ValueRef -> FFI.ValueRef -> LLVMModule ()
>   llvmSetInitialiser g v = liftIO $ FFI.llvmSetInitialiser g v
    
    {----------------------------------------------------------------------}
    {-- LLVM Functions                                                    -}
    {----------------------------------------------------------------------}
    
    Adds a function with the specified name and type to the current module.
    
>   llvmAddFunction :: String -> FFI.TypeRef -> LLVMModule FFI.ValueRef
>   llvmAddFunction n t = get >>= 
>       \m -> liftIO $ withCString n $ 
>       \cstr -> FFI.llvmAddFunction m cstr t 

    Gets the ValueRef of a function with the specified name.

>   llvmGetNamedFunction :: String -> LLVMModule FFI.ValueRef
>   llvmGetNamedFunction n = get >>=
>       \m -> liftIO $ withCString n $
>       \s -> FFI.llvmGetNamedFunction m s

>   llvmAddFunctionAttr :: FFI.ValueRef -> FFI.Attribute -> LLVMModule ()
>   llvmAddFunctionAttr f a = liftIO $ FFI.llvmAddFunctionAttr f (FFI.fromAttribute a)

>   llvmGetParam :: FFI.ValueRef -> Int -> LLVMModule FFI.ValueRef
>   llvmGetParam f n = liftIO $ FFI.llvmGetParam f (fromIntegral n)

>   llvmAppendBasicBlock :: FFI.ValueRef -> String -> LLVMModule FFI.BasicBlockRef
>   llvmAppendBasicBlock f n = liftIO $ withCString n $
>       \s -> FFI.llvmAppendBasicBlock f s

>   llvmSetCallConv :: FFI.ValueRef -> FFI.CallingConv -> LLVMModule ()
>   llvmSetCallConv f c = liftIO $ FFI.llvmSetCallConv f (FFI.fromCallingConv c)

>   llvmAddAttribute :: FFI.ValueRef -> Int -> FFI.Attribute -> LLVMModule ()
>   llvmAddAttribute v i a = liftIO $ FFI.llvmAddAttribute v (fromIntegral i) (FFI.fromAttribute a) 

>   llvmSetTailCall :: FFI.ValueRef -> Bool -> LLVMModule ()
>   llvmSetTailCall f t = liftIO $ FFI.llvmSetTailCall f (fromBool t)
    
{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}          
