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

-- |SIPC Roles
#c
enum SIPCRole {
 Sipc_creator  = SIPC_CREATOR,
 Sipc_sender   = SIPC_SENDER,
 Sipc_receiver = SIPC_RECEIVER
};
#endc
{#enum SIPCRole {} deriving (Eq, Show)#}

-- |SIPC Types
#c
enum SIPCType {
 Sipc_sysv_shm     = SIPC_SYSV_SHM,
 Sipc_sysv_mqueues = SIPC_SYSV_MQUEUES,
 Sipc_num_types    = SIPC_NUM_TYPES
};
#endc
{#enum SIPCType {} deriving (Eq, Show)#}

-- |SIPC behaviors, for sipc_ioctl()
#c
enum SIPCIOCtl {
 Sipc_block   = SIPC_BLOCK,
 Sipc_noblock = SIPC_NOBLOCK
};
#endc
{#enum SIPCIOCtl {} deriving (Eq, Show)#}

{#fun sipc_unlink {`String', _cFromEnum `SIPCType'} -> `()' #}

-- |Convert a Haskell enumeration to C.
--
--  Explicitly added to this module since this function
--  is deprecated from C2HS.
_cFromEnum :: (Enum e, Integral i) => e -> i
_cFromEnum  = fromIntegral . fromEnum


-- Only here because of how the test file is structured
main :: IO ()
main = do
  putStrLn ""
