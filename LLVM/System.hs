{--------------------------------------------------------------------------------------------------
                                           Cada Compiler                                           
                                       Michael Benjamin Gale                                       
--------------------------------------------------------------------------------------------------}

module LLVM.System (
    LLVMLinkerSettings(..),
    llvmLinkFiles
) where

    {----------------------------------------------------------------------}
    {-- Module Imports                                                    -}
    {----------------------------------------------------------------------}
    
    import System.Process
    import Text.Printf
    
    data LLVMLinkerSettings = LLVMLinkerSettings {
        llvmLinkerTarget :: String,
        llvmInputFiles   :: [String]
    }
    
    {----------------------------------------------------------------------}
    {-- LLVM Program Names                                                -}
    {----------------------------------------------------------------------}
    
    llvmLinker :: LLVMLinkerSettings -> String
    llvmLinker s = printf "llvm-ld -o %s %s" (llvmLinkerTarget s) (unwords (llvmInputFiles s))
    
    {----------------------------------------------------------------------}
    {-- LLVM System Tasks                                                 -}
    {----------------------------------------------------------------------}
                           
    llvmLinkFiles :: LLVMLinkerSettings -> IO ()
    llvmLinkFiles s = do putStrLn $ llvmLinker s
                         p <- runCommand $ llvmLinker s
                         waitForProcess p
                         return ()

{--------------------------------------------------------------------------------------------------
                                            End of File                                            
--------------------------------------------------------------------------------------------------}          
