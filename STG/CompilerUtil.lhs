{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

This module provides utility functions which are used during code generation.

> module STG.CompilerUtil (
>   stgClosure,
>   STGFunction,
>   stgGetBpVar,
>   stgGetSpVar,
>   stgGetHpVar,
>   stgGetRpVar,
>   stgRefsToLocals,
>   stgFunction,
>   stgWithFunction,
>   stgAdjustPointer,
>   stgPopStack,
>   stgAllocateHeap,
>   stgValToFunPtr,
>   stgJump
> ) where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
    
>   import Control.Monad.State
    
>   import LLVM.Core
>   import LLVM.Types
>   import LLVM.Const
>   import LLVM.Structs
>   import LLVM.Builder

    {----------------------------------------------------------------------}
    {-- STG Closures                                                      -}
    {----------------------------------------------------------------------}

>   stgClosure :: String -> [ValueRef] -> LLVMModule ValueRef
>   stgClosure n vs = do
>       t  <- llvmInt32Type
>       st <- lift $ llvmMakeNamedStruct (n ++ "_closure_struct")
>       lift $ llvmSetStructBody st [t] True
>       g  <- llvmAddGlobal (n ++ "_closure") st
>       gv <- llvmConstNamedStruct st vs
>       llvmSetInitialiser g gv
>       return g
    
    {----------------------------------------------------------------------}
    {-- STG Functions                                                     -}
    {----------------------------------------------------------------------}

    Each STG function has access to the base address (address of the current
    closure in memory), stack pointer, heap pointer and return stack pointer.
    
>   data STGVars = STGVars
>       {
>           stgBpVar :: ValueRef,
>           stgSpVar :: ValueRef,
>           stgHpVar :: ValueRef,
>           stgRpVar :: ValueRef
>       }

>   type STGFunction = StateT STGVars LLVMBuilder

>   stgGetBpVar :: STGFunction ValueRef
>   stgGetBpVar = fmap stgBpVar get

>   stgGetSpVar :: STGFunction ValueRef
>   stgGetSpVar = fmap stgSpVar get

>   stgGetHpVar :: STGFunction ValueRef
>   stgGetHpVar = fmap stgHpVar get

>   stgGetRpVar :: STGFunction ValueRef
>   stgGetRpVar = fmap stgRpVar get

>   stgWithBuilder :: LLVMBuilder a -> STGFunction a
>   stgWithBuilder = lift
    
    Generates the type for STG functions. Each function takes 4 arguments:
    base/node address, stack pointer, heap pointer and return stack pointer.
    
>   stgFunctionType :: LLVMModule TypeRef
>   stgFunctionType = do
>       t  <- llvmInt32Type
>       pt <- llvmInt32PtrType
>       rt <- llvmVoidType
>       llvmMakeFunctionType False rt [pt, pt, pt, t]

>   stgFunctionTypePtr :: LLVMModule TypeRef
>   stgFunctionTypePtr = do
>       ft <- stgFunctionType
>       llvmPointerType ft

>   stgRefToLocal :: String -> ValueRef -> Int -> LLVMBuilder ValueRef
>   stgRefToLocal n f i = do
>       p <- lift $ llvmGetParam f i
>       lift $ lift $ llvmSetValueName p n
>       t <- lift $ llvmInt32PtrType
>       v <- llvmBuildAlloca (n ++ "_Var") t
>       llvmBuildStore p v
>       return v

>   stgRefsToLocals :: ValueRef -> LLVMBuilder (ValueRef, ValueRef, ValueRef, ValueRef)
>   stgRefsToLocals f = do 
>       bp <- stgRefToLocal "Base" f 0
>       sp <- stgRefToLocal "Sp" f 1
>       hp <- stgRefToLocal "Hp" f 2
>       p  <- lift $ llvmGetParam f 3
>       lift $ lift $ llvmSetValueName p "R1"
>       t  <- lift $ llvmInt32Type
>       rp <- llvmBuildAlloca "R1_Var" t
>       llvmBuildStore p rp
>       return (bp, sp, hp, rp)

>   stgFunction :: String -> LLVMModule ValueRef
>   stgFunction n = do
>       t <- stgFunctionType
>       llvmAddFunction n t

>   stgFunctionEntry :: ValueRef -> STGFunction a -> LLVMBuilder ()
>   stgFunctionEntry f m = do
>       (bp, sp, hp, rp) <- stgRefsToLocals f
>       execStateT m $ STGVars bp sp hp rp
>       return ()

>   stgWithFunction :: String -> STGFunction a -> LLVMModule ValueRef
>   stgWithFunction n m = do
>       f <- stgFunction n
>       e <- llvmAppendBasicBlock f "entry"
>       llvmWithBuilder e (stgFunctionEntry f m)
>       return f

>   stgAdjust :: ValueRef -> ValueRef -> Int -> LLVMBuilder ValueRef
>   stgAdjust l r o | o > 0     = llvmBuildAdd l r
>                   | otherwise = llvmBuildSub l r
    
    Loads the value of a pointer variable into a register, adjusts it and then
    stores the new value in the variable.
    
>   stgAdjustPointer :: ValueRef -> Int -> STGFunction ValueRef
>   stgAdjustPointer p o | o == 0    = do return p
>                        | otherwise = do r <- lift $ lift $ llvmInt32Const o
>                                         l <- lift $ llvmBuildLoad "" p
>                                         v <- lift $ stgAdjust l r o
>                                         lift $ llvmBuildStore v p

    {----------------------------------------------------------------------}
    {-- STG Pop Stack                                                     -}
    {----------------------------------------------------------------------}
    
    Gets the value of the item at the specified index on the stack. Note that this
    will not remove the item from the stack and that the stack pointer will not be
    adjusted.
    
>   stgPopStack :: Int -> STGFunction ValueRef
>   stgPopStack i = do 
>       sp <- stgGetSpVar
>       stgWithBuilder $ do
>           sv <- llvmBuildLoad "" sp
>           iv <- lift $ llvmInt32Const (i * 4) -- 32 bit words (4 bytes)
>           ep <- llvmBuildInBoundsGEP sv [iv] 
>           llvmBuildLoad "" ep

    {----------------------------------------------------------------------}
    {-- STG Dynamic Closure                                               -}
    {----------------------------------------------------------------------}

    Generates instructions which create a closure on the heap at runtime. We
    expect the function f to be a pointer to a STG function and the
    arguments to be of type i32*.
    
>   stgDynamicClosure :: ValueRef -> [ValueRef] -> STGFunction ()
>   stgDynamicClosure f ps = do return ()
    
    {----------------------------------------------------------------------}
    {-- STG Allocate Heap Space                                           -}
    {----------------------------------------------------------------------}

    Allocates x many words on the heap. Note that we use the getElementPtr (GEP)
    instruction in the LLVM instruction set rather than the add instruction. This
    makes sense, because LLVM will "index" the Hp pointer by the specified constant
    multiplied by the word size. This way, we do not have to worry about the word
    size here, because we get it for free from the LLVM compiler.

>   stgAllocateHeap :: Int -> STGFunction ()
>   stgAllocateHeap x = do
>       hp <- stgGetHpVar
>       stgWithBuilder $ do
>           i  <- lift $ llvmInt32Const x
>           hv <- llvmBuildInBoundsGEP hp [i] 
>           t  <- lift $ llvmInt32Type
>           pt <- lift $ llvmInt32PtrType
>           v  <- llvmBuildPtrToInt hv t
>           vp <- llvmBuildIntToPtr v pt
>           llvmBuildStore vp hp
>       -- todo: check for heap overflow
>       return ()

    {----------------------------------------------------------------------}
    {-- STG Word to Function Pointer                                      -}
    {----------------------------------------------------------------------}
    
    Takes an i32 value and casts it to the STG function type.

>   stgValToFunPtr :: ValueRef -> STGFunction ValueRef
>   stgValToFunPtr v = stgWithBuilder $ do
>       ft <- lift stgFunctionTypePtr
>       llvmBuildIntToPtr v ft
    
    {----------------------------------------------------------------------}
    {-- STG Jump                                                          -}
    {----------------------------------------------------------------------}
    
    Loads the values of the four STG variables into registers and jumps to 
    the specified function with the values of those variables as arguments. 
    We assume that f has the correct LLVM type already (i.e. a pointer to a
    STG function).
    
>   stgJump :: ValueRef -> STGFunction ()
>   stgJump f = do

    Get the values of all four STG variables.

>       bp <- stgGetBpVar
>       sp <- stgGetSpVar
>       hp <- stgGetHpVar
>       rp <- stgGetRpVar
>       stgWithBuilder $ do
>           bv <- llvmBuildLoad "" bp
>           sv <- llvmBuildLoad "" sp
>           hv <- llvmBuildLoad "" hp
>           rv <- llvmBuildLoad "" rp

    Add the call instruction for function f. We give it the values of the
    four STG variables as arguments.

>           fc <- llvmBuildCall f [bv,sv,hv,rv]

    Make the function call a tail call and use GHC's calling convention.

>           lift $ llvmSetTailCall fc True
>           lift $ llvmSetCallConv fc GHC 

    When we return from the tail call above, return nothing to the calling
    procedure on the machine's stack. Note that data will always be
    returned using the stacks provided by the STG machine instead.

>           llvmBuildRetVoid
>       return ()
    
{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}          
