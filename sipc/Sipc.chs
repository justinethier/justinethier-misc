{-# LANGUAGE CPP, ForeignFunctionInterface#-}

{-
 Build using:
 c2hs -l Sipc.chs

 To create the C2HS module 
 -}

module Main where -- TODO: Change to something like SELinux.SIPC for the library

-- import Monad
import C2HS

#include <sipc/sipc.h>

#c
enum SIPCType {
 Sipc_sysv_shm     = SIPC_SYSV_SHM,
 Sipc_sysv_mqueues = SIPC_SYSV_MQUEUES,
 Sipc_num_types    = SIPC_NUM_TYPES
};
#endc
{#enum SIPCType {}#}

{#fun sipc_unlink {`String', cFromEnum `SIPCType'} -> `()' #}

main :: IO ()
main = do
  putStrLn ""
