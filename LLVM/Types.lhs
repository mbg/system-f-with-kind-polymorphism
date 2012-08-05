{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

> module LLVM.Types (
>   llvmVoidType,
>   llvmInt1Type,
>   llvmInt8Type,
>   llvmInt16Type,
>   llvmInt32Type,
>   llvmInt64Type,
>   llvmIntType,
>   llvmMakeFunctionType,
>   llvmArrayType,
>   llvmPointerType,
>   llvmInt32PtrType,
>   FFI.TypeRef
> )
> where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}

>   import Control.Monad.State (get, lift, liftIO)
    
>   import Foreign.C.String (withCString)
>   import Foreign.Marshal.Array (withArrayLen)
>   import Foreign.Marshal.Utils (fromBool)
    
>   import qualified LLVM.FFI.Core as FFI
    
>   import LLVM.Core

    {----------------------------------------------------------------------}
    {-- Misc Types                                                        -}
    {----------------------------------------------------------------------}
    
>   llvmVoidType :: LLVMModule FFI.TypeRef
>   llvmVoidType = liftIO $ FFI.llvmVoidType
    
    {----------------------------------------------------------------------}
    {-- Integer Types                                                     -}
    {----------------------------------------------------------------------}
    
>   llvmInt1Type :: LLVMModule FFI.TypeRef
>   llvmInt1Type = lift $ get >>= \c -> liftIO $ FFI.llvmInt1Type c
    
>   llvmInt8Type :: LLVMModule FFI.TypeRef
>   llvmInt8Type = lift $ get >>= \c -> liftIO $ FFI.llvmInt8Type c
    
>   llvmInt16Type :: LLVMModule FFI.TypeRef
>   llvmInt16Type = lift $ get >>= \c -> liftIO $ FFI.llvmInt16Type c
    
>   llvmInt32Type :: LLVMModule FFI.TypeRef
>   llvmInt32Type = lift $ get >>= \c -> liftIO $ FFI.llvmInt32Type c
    
>   llvmInt64Type :: LLVMModule FFI.TypeRef
>   llvmInt64Type = lift $ get >>= \c -> liftIO $ FFI.llvmInt64Type c
    
>   llvmIntType :: Int -> LLVMModule FFI.TypeRef
>   llvmIntType s = lift $ get >>= \c -> liftIO $ FFI.llvmIntType c $ fromIntegral s
    
    {----------------------------------------------------------------------}
    {-- Function Types                                                    -}
    {----------------------------------------------------------------------}
    
>   llvmMakeFunctionType :: Bool -> FFI.TypeRef -> [FFI.TypeRef] -> LLVMModule FFI.TypeRef
>   llvmMakeFunctionType v r ts = liftIO $ withArrayLen ts $ 
>       \len ptr -> FFI.llvmCreateFunctionType r ptr (fromIntegral len) (fromBool v)

    {----------------------------------------------------------------------}
    {-- Pointer Types                                                     -}
    {----------------------------------------------------------------------}
    
>   llvmArrayType :: FFI.TypeRef -> LLVMModule FFI.TypeRef
>   llvmArrayType t = liftIO $ FFI.llvmArrayType t 0
    
>   llvmPointerType :: FFI.TypeRef -> LLVMModule FFI.TypeRef
>   llvmPointerType t = liftIO $ FFI.llvmPointerType t 0

>   llvmInt32PtrType :: LLVMModule FFI.TypeRef
>   llvmInt32PtrType = llvmInt32Type >>= \t -> llvmPointerType t

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}          
