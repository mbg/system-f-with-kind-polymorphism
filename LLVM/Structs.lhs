{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

> module LLVM.Structs (
>   llvmMakeStructType,
>   llvmMakeNamedStruct,
>   llvmSetStructBody
> ) where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
    
>   import qualified LLVM.FFI.Core as FFI

>   import Control.Monad.State

>   import Foreign.C.String (withCString)
>   import Foreign.Marshal.Array (withArrayLen)
>   import Foreign.Marshal.Utils (fromBool)
    
>   import LLVM.Core
>   import LLVM.Types

    {----------------------------------------------------------------------}
    {-- Structure Types                                                   -}
    {----------------------------------------------------------------------}
    
>   llvmMakeStructType :: [FFI.TypeRef] -> Bool -> IO FFI.TypeRef
>   llvmMakeStructType ts p = withArrayLen ts $
>       \len ptr -> FFI.llvmCreateStructType ptr (fromIntegral len) (fromBool p)

>   llvmMakeNamedStruct :: String -> LLVMContext FFI.TypeRef
>   llvmMakeNamedStruct xs = get >>=
>       \c   -> liftIO $ withCString xs $
>       \str -> FFI.llvmCreateNamedStruct c str

>   llvmSetStructBody :: FFI.TypeRef -> [FFI.TypeRef] -> Bool -> LLVMContext ()
>   llvmSetStructBody s ts p = liftIO $ withArrayLen ts $
>       \len ptr -> FFI.llvmSetStructBody s ptr (fromIntegral len) (fromBool p)

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}          
