{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

This module provides an interface to the LLVM API for constants.

> module LLVM.Const (
>   llvmInt32Const,
>   llvmConstAdd,
>   llvmConstPtrToInt,
>   llvmConstNamedStruct
> ) where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
    
>   import Control.Monad.State (liftIO)
>   import Foreign.Marshal.Utils (fromBool)
>   import Foreign.Marshal.Array (withArrayLen)
    
>   import qualified LLVM.FFI.Core as FFI

>   import LLVM.Core
>   import LLVM.Types

    {----------------------------------------------------------------------}
    {-- Constants                                                         -}
    {----------------------------------------------------------------------}

>   llvmInt32Const :: Int -> LLVMModule FFI.ValueRef
>   llvmInt32Const v = llvmInt32Type >>=
>       \t -> liftIO $ FFI.llvmConstInt t (fromIntegral v) (fromBool True)

    {----------------------------------------------------------------------}
    {-- Functions on Constants                                            -}
    {----------------------------------------------------------------------}

>   llvmConstAdd :: FFI.ValueRef -> FFI.ValueRef -> LLVMModule FFI.ValueRef
>   llvmConstAdd l r = liftIO $ FFI.llvmConstAdd l r
    
>   llvmConstPtrToInt :: FFI.ValueRef -> FFI.TypeRef -> LLVMModule FFI.ValueRef
>   llvmConstPtrToInt v t = liftIO $ FFI.llvmConstPtrToInt v t

>   llvmConstNamedStruct :: FFI.TypeRef -> [FFI.ValueRef] -> LLVMModule FFI.ValueRef
>   llvmConstNamedStruct t ps = liftIO $ withArrayLen ps $ 
>       \len ptr -> FFI.llvmConstNamedStruct t ptr (fromIntegral len)
    
{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}  