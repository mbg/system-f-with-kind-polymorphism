{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

{-# LANGUAGE ForeignFunctionInterface, EmptyDataDecls, DeriveDataTypeable #-}

module LLVM.FFI.Core(
    ContextRef(..),
    ModuleRef(..),
    TypeRef(..),
    ValueRef(..),
    BuilderRef(..),
    BasicBlockRef(..),
    
    Visibility(..),
    fromVisibility,
    toVisibility,
    
    Linkage(..),
    fromLinkage,
    llvmCreateContext,
    
    CallingConv(..),
    fromCallingConv,
    
    Attribute(..),
    fromAttribute,
    
    llvmGetGlobalContext,
    llvmDisposeContext,
    llvmCreateModuleWithName,
    llvmSetModuleInlineAsm,
    llvmDumpModule,
    llvmWriteModuleToFile,
    llvmDisposeModule,
    
    llvmDumpValue,
    llvmSetValueName,
    
    llvmVoidType,
    llvmInt1Type,
    llvmInt8Type,
    llvmInt16Type,
    llvmInt32Type,
    llvmInt64Type,
    llvmIntType,
    llvmArrayType,
    llvmPointerType,
    llvmCreateFunctionType,
    llvmCreateStructType,
    llvmCreateNamedStruct,
    
    llvmConstAdd,
    llvmConstPtrToInt,
    
    llvmSetStructBody,
    llvmConstInt,
    
    llvmConstNamedStruct,
    
    llvmAddFunction,
    llvmGetNamedFunction,
    llvmAddFunctionAttr,
    
    llvmSetLinkage,
    llvmSetVisibility,
    llvmGetParam,
    
    llvmAppendBasicBlock,
    
    llvmSetCallConv,
    llvmAddAttribute,
    llvmSetTailCall,
    
    llvmAddGlobal,
    llvmSetGlobalConstant,
    llvmSetInitialiser,
    
    llvmCreateBuilder,
    llvmPositionBuilderAtEnd,
    llvmDisposeBuilder,
    
    llvmBuildRetVoid,
    
    llvmBuildAdd,
    llvmBuildSub,
    
    llvmBuildAlloca,
    llvmBuildLoad,
    llvmBuildStore,
    llvmBuildGEP,
    llvmBuildInBoundsGEP,
    
    llvmBuildBitCast,
    llvmBuildPtrToInt,
    llvmBuildIntToPtr,
    
    llvmBuildCall
) where

#define __STDC_LIMIT_MACROS
#define __STDC_CONSTANT_MACROS

import Data.Typeable(Typeable)
import Foreign.C.String (CString)
import Foreign.C.Types (CDouble(..), CInt(..), CUInt(..), CLLong(..), CULong(..))
import Foreign.Ptr (Ptr, FunPtr)

#include <llvm-c/Core.h>
#include <llvm-c/BitWriter.h>

data Context deriving (Typeable)
data Module deriving (Typeable)
data Type deriving (Typeable)
data Value deriving (Typeable)
data Builder deriving (Typeable)
data BasicBlock deriving (Typeable)

type ContextRef    = Ptr Context
type ModuleRef     = Ptr Module
type TypeRef       = Ptr Type
type ValueRef      = Ptr Value
type BuilderRef    = Ptr Builder
type BasicBlockRef = Ptr BasicBlock

data Visibility = Visible
                | Hidden
                | Protected
                
fromVisibility :: Visibility -> CUInt
fromVisibility Visible   = (#const LLVMDefaultVisibility)
fromVisibility Hidden    = (#const LLVMHiddenVisibility)
fromVisibility Protected = (#const LLVMProtectedVisibility)

toVisibility :: CUInt -> Visibility
toVisibility c | c == (#const LLVMDefaultVisibility)   = Visible
toVisibility c | c == (#const LLVMHiddenVisibility)    = Hidden
toVisibility c | c == (#const LLVMProtectedVisibility) = Protected

data Linkage = ExternalLinkage
             | AvailableExternallyLinkage
             | LinkOnceAnyLinkage
             | LinkOnceODRLinkage
             | WeakAnyLinkage
             | WeakODRLinkage
             | AppendingLinkage
             | InternalLinkage
             | PrivateLinkage
             | DLLImportLinkage
             | DLLExportLinkage
             | ExternalWeakLinkage
             | GhostLinkage
             | CommonLinkage
             | LinkerPrivateLinkage
             | LinkerPrivateWeakLinkage
             | LinkerPrivateWeakDefAutoLinkage
             
fromLinkage :: Linkage -> CUInt
fromLinkage InternalLinkage = (#const LLVMInternalLinkage)
fromLinkage CommonLinkage   = (#const LLVMCommonLinkage)

data CallingConv = C
                 | GHC
                 
fromCallingConv :: CallingConv -> CUInt
fromCallingConv C   = (#const LLVMCCallConv)
fromCallingConv GHC = 10

data Attribute = ZExt
               | SExt
               | NoReturn
               | InReg
               | StructRet
               | NoUnwind
               | NoAlias
               | ByVal
               | Nest
               | ReadNone
               | ReadOnly
               | NoInline
               | AlwaysInline
               | OptimizeForSize
               | StackProtect
               | StackProtectReq
               | Alignment
               | NoCapture
               | NoRedZone
               | NoImplicitFloat
               | Naked
               | InlineHint
               | StackAlignment
               | ReturnsTwice
               | UWTable
               | NonLazyBind
               
fromAttribute :: Attribute -> CUInt
fromAttribute NoUnwind = (#const LLVMNoUnwindAttribute)

foreign import ccall unsafe "LLVMContextCreate" llvmCreateContext :: IO ContextRef  
foreign import ccall unsafe "LLVMGetGlobalContext" llvmGetGlobalContext :: IO ContextRef 
foreign import ccall unsafe "LLVMContextDispose" llvmDisposeContext :: ContextRef -> IO ()
 
foreign import ccall unsafe "LLVMModuleCreateWithName" llvmCreateModuleWithName :: CString -> IO ModuleRef  
foreign import ccall unsafe "LLVMSetModuleInlineAsm" llvmSetModuleInlineAsm :: ModuleRef -> CString -> IO ()  
foreign import ccall unsafe "LLVMDumpModule" llvmDumpModule :: ModuleRef -> IO ()
foreign import ccall unsafe "LLVMWriteBitcodeToFile" llvmWriteModuleToFile :: ModuleRef -> CString -> IO ()
foreign import ccall unsafe "LLVMDisposeModule" llvmDisposeModule :: ModuleRef -> IO ()

foreign import ccall unsafe "LLVMDumpValue" llvmDumpValue :: ValueRef -> IO ()
foreign import ccall unsafe "LLVMSetValueName" llvmSetValueName :: ValueRef -> CString -> IO ()

foreign import ccall unsafe "LLVMVoidType" llvmVoidType :: IO TypeRef

foreign import ccall unsafe "LLVMInt1TypeInContext" llvmInt1Type :: ContextRef -> IO TypeRef
foreign import ccall unsafe "LLVMInt8TypeInContext" llvmInt8Type :: ContextRef -> IO TypeRef
foreign import ccall unsafe "LLVMInt16TypeInContext" llvmInt16Type :: ContextRef -> IO TypeRef
foreign import ccall unsafe "LLVMInt32TypeInContext" llvmInt32Type :: ContextRef -> IO TypeRef
foreign import ccall unsafe "LLVMInt64TypeInContext" llvmInt64Type :: ContextRef -> IO TypeRef
foreign import ccall unsafe "LLVMIntTypeInContext" llvmIntType :: ContextRef -> CUInt -> IO TypeRef
foreign import ccall unsafe "LLVMArrayType" llvmArrayType :: TypeRef -> CUInt -> IO TypeRef
foreign import ccall unsafe "LLVMPointerType" llvmPointerType :: TypeRef -> CUInt -> IO TypeRef

foreign import ccall unsafe "LLVMFunctionType" llvmCreateFunctionType :: TypeRef -> Ptr TypeRef -> CUInt -> CInt -> IO TypeRef

foreign import ccall unsafe "LLVMStructType" llvmCreateStructType :: Ptr TypeRef -> CUInt -> CInt -> IO TypeRef
foreign import ccall unsafe "LLVMStructCreateNamed" llvmCreateNamedStruct :: ContextRef -> CString -> IO TypeRef
foreign import ccall unsafe "LLVMStructSetBody" llvmSetStructBody :: TypeRef -> Ptr TypeRef -> CUInt -> CInt -> IO ()

foreign import ccall unsafe "LLVMConstInt" llvmConstInt :: TypeRef -> CULong -> Int -> IO ValueRef
foreign import ccall unsafe "LLVMConstStruct" llvmConstStruct :: Ptr ValueRef -> CUInt -> Int -> IO ValueRef
foreign import ccall unsafe "LLVMConstNamedStruct" llvmConstNamedStruct :: TypeRef -> Ptr ValueRef -> CUInt -> IO ValueRef

foreign import ccall unsafe "LLVMConstAdd" llvmConstAdd :: ValueRef -> ValueRef -> IO ValueRef
foreign import ccall unsafe "LLVMConstPtrToInt" llvmConstPtrToInt :: ValueRef -> TypeRef -> IO ValueRef

foreign import ccall unsafe "LLVMAddFunction" llvmAddFunction :: ModuleRef -> CString -> TypeRef -> IO ValueRef
foreign import ccall unsafe "LLVMGetNamedFunction" llvmGetNamedFunction :: ModuleRef -> CString -> IO ValueRef
foreign import ccall unsafe "LLVMAddFunctionAttr" llvmAddFunctionAttr :: ValueRef -> CUInt -> IO ()

foreign import ccall unsafe "LLVMSetLinkage" llvmSetLinkage :: ValueRef -> CUInt -> IO ()
foreign import ccall unsafe "LLVMSetVisibility" llvmSetVisibility :: ValueRef -> CUInt -> IO ()

foreign import ccall unsafe "LLVMGetParam" llvmGetParam :: ValueRef -> CUInt -> IO ValueRef

foreign import ccall unsafe "LLVMAppendBasicBlock" llvmAppendBasicBlock :: ValueRef -> CString -> IO BasicBlockRef

foreign import ccall unsafe "LLVMSetInstructionCallConv" llvmSetCallConv :: ValueRef -> CUInt -> IO ()
foreign import ccall unsafe "LLVMAddInstrAttribute" llvmAddAttribute :: ValueRef -> CUInt -> CUInt -> IO ()
foreign import ccall unsafe "LLVMSetTailCall" llvmSetTailCall :: ValueRef -> Int -> IO ()

foreign import ccall unsafe "LLVMAddGlobal" llvmAddGlobal :: ModuleRef -> TypeRef -> CString -> IO ValueRef
foreign import ccall unsafe "LLVMSetGlobalConstant" llvmSetGlobalConstant :: ValueRef -> CInt -> IO ()
foreign import ccall unsafe "LLVMSetInitializer" llvmSetInitialiser :: ValueRef -> ValueRef -> IO ()

foreign import ccall unsafe "LLVMCreateBuilder" llvmCreateBuilder :: IO BuilderRef
foreign import ccall unsafe "LLVMPositionBuilderAtEnd" llvmPositionBuilderAtEnd :: BuilderRef -> BasicBlockRef -> IO ()
foreign import ccall unsafe "LLVMDisposeBuilder" llvmDisposeBuilder :: BuilderRef -> IO ()

foreign import ccall unsafe "LLVMBuildRetVoid" llvmBuildRetVoid :: BuilderRef -> IO ValueRef

foreign import ccall unsafe "LLVMBuildAdd" llvmBuildAdd :: BuilderRef -> ValueRef -> ValueRef -> CString -> IO ValueRef
foreign import ccall unsafe "LLVMBuildSub" llvmBuildSub :: BuilderRef -> ValueRef -> ValueRef -> CString -> IO ValueRef

foreign import ccall unsafe "LLVMBuildAlloca" llvmBuildAlloca :: BuilderRef -> TypeRef -> CString -> IO ValueRef 
foreign import ccall unsafe "LLVMBuildLoad" llvmBuildLoad :: BuilderRef -> ValueRef -> CString -> IO ValueRef
foreign import ccall unsafe "LLVMBuildStore" llvmBuildStore :: BuilderRef -> ValueRef -> ValueRef -> IO ValueRef 
foreign import ccall unsafe "LLVMBuildGEP" llvmBuildGEP :: BuilderRef -> ValueRef -> Ptr ValueRef -> CUInt -> CString -> IO ValueRef
foreign import ccall unsafe "LLVMBuildInBoundsGEP" llvmBuildInBoundsGEP :: BuilderRef -> ValueRef -> Ptr ValueRef -> CUInt -> CString -> IO ValueRef

foreign import ccall unsafe "LLVMBuildBitCast" llvmBuildBitCast :: BuilderRef -> ValueRef -> TypeRef -> CString -> IO ValueRef
foreign import ccall unsafe "LLVMBuildPtrToInt" llvmBuildPtrToInt :: BuilderRef -> ValueRef -> TypeRef -> CString -> IO ValueRef
foreign import ccall unsafe "LLVMBuildIntToPtr" llvmBuildIntToPtr :: BuilderRef -> ValueRef -> TypeRef -> CString -> IO ValueRef

foreign import ccall unsafe "LLVMBuildCall" llvmBuildCall :: BuilderRef -> ValueRef -> Ptr ValueRef -> CUInt -> CString -> IO ValueRef

