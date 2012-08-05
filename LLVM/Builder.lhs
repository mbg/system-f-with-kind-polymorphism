{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

> module LLVM.Builder (
>   LLVMBuilder,
>   llvmWithBuilder,
>   llvmBuildRetVoid,
>   llvmBuildAdd,
>   llvmBuildSub,
>   llvmBuildAlloca,
>   llvmBuildStore,
>   llvmBuildGEP,
>   llvmBuildInBoundsGEP,
>   llvmBuildLoad,
>   llvmBuildPtrToInt,
>   llvmBuildIntToPtr,
>   llvmBuildCall
> ) where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
    
>   import Control.Monad.State
>   import Foreign.C.String (withCString)
>   import Foreign.Marshal.Array (withArrayLen)
    
>   import qualified LLVM.FFI.Core as FFI

>   import LLVM.Core

    {----------------------------------------------------------------------}
    {-- LLVM Builder                                                      -}
    {----------------------------------------------------------------------}
    
>   type LLVMBuilder = StateT FFI.BuilderRef LLVMModule

>   llvmWithBuilder :: FFI.BasicBlockRef -> LLVMBuilder a -> LLVMModule a
>   llvmWithBuilder e f = do
>       b <- liftIO $ FFI.llvmCreateBuilder
>       liftIO $ FFI.llvmPositionBuilderAtEnd b e
>       r <- evalStateT f b
>       liftIO $ FFI.llvmDisposeBuilder b
>       return r

    {----------------------------------------------------------------------}
    {-- LLVM Instructions                                                 -}
    {----------------------------------------------------------------------}
    
>   llvmBuildRetVoid :: LLVMBuilder FFI.ValueRef
>   llvmBuildRetVoid = get >>= 
>       \b -> liftIO $ FFI.llvmBuildRetVoid b
    
>   llvmBuildAdd :: FFI.ValueRef -> FFI.ValueRef -> LLVMBuilder FFI.ValueRef
>   llvmBuildAdd l r = get >>=
>       \b -> liftIO $ withCString "" $
>       \s -> FFI.llvmBuildAdd b l r s

>   llvmBuildSub :: FFI.ValueRef -> FFI.ValueRef -> LLVMBuilder FFI.ValueRef
>   llvmBuildSub l r = get >>=
>       \b -> liftIO $ withCString "" $
>       \s -> FFI.llvmBuildSub b l r s
    
>   llvmBuildAlloca :: String -> FFI.TypeRef -> LLVMBuilder FFI.ValueRef
>   llvmBuildAlloca n t = get >>=
>       \b -> liftIO $ withCString n $
>       \s -> FFI.llvmBuildAlloca b t s

>   llvmBuildStore :: FFI.ValueRef -> FFI.ValueRef -> LLVMBuilder FFI.ValueRef
>   llvmBuildStore v p = get >>=
>       \b -> liftIO $ FFI.llvmBuildStore b v p

>   llvmBuildGEP :: FFI.ValueRef -> [FFI.ValueRef] -> LLVMBuilder FFI.ValueRef
>   llvmBuildGEP p is = get >>=
>       \b       -> liftIO $ withArrayLen is $
>       \len ptr -> withCString "" $
>       \s       -> FFI.llvmBuildGEP b p ptr (fromIntegral len) s

>   llvmBuildInBoundsGEP :: FFI.ValueRef -> [FFI.ValueRef] -> LLVMBuilder FFI.ValueRef
>   llvmBuildInBoundsGEP p is = get >>=
>       \b       -> liftIO $ withArrayLen is $
>       \len ptr -> withCString "" $
>       \s       -> FFI.llvmBuildGEP b p ptr (fromIntegral len) s

>   llvmBuildLoad :: String -> FFI.ValueRef -> LLVMBuilder FFI.ValueRef
>   llvmBuildLoad n p = get >>=
>       \b -> liftIO $ withCString n $
>       \s -> FFI.llvmBuildLoad b p s

>   llvmBuildPtrToInt :: FFI.ValueRef -> FFI.TypeRef -> LLVMBuilder FFI.ValueRef
>   llvmBuildPtrToInt v t = get >>=
>       \b -> liftIO $ withCString "" $
>       \s -> FFI.llvmBuildPtrToInt b v t s

>   llvmBuildIntToPtr :: FFI.ValueRef -> FFI.TypeRef -> LLVMBuilder FFI.ValueRef
>   llvmBuildIntToPtr v t = get >>=
>       \b -> liftIO $ withCString "" $
>       \s -> FFI.llvmBuildIntToPtr b v t s

>   llvmBuildCall :: FFI.ValueRef -> [FFI.ValueRef] -> LLVMBuilder FFI.ValueRef
>   llvmBuildCall f ps = get >>=
>       \b       -> liftIO $ withArrayLen ps $
>       \len ptr -> withCString "" $
>       \s       -> FFI.llvmBuildCall b f ptr (fromIntegral len) s

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}          
