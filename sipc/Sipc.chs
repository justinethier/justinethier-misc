{-# LANGUAGE ForeignFunctionInterface#-}

module Main where -- TODO: Change to something like SELinux.SIPC for the library

-- import Monad
import C2HS

-- The sipc header must be installed on your system
-- in order to compile this module!!
#include <sipc/sipc.h>

#c
enum SIPCRole {
 Sipc_creator  = SIPC_CREATOR,
 Sipc_sender   = SIPC_SENDER,
 Sipc_receiver = SIPC_RECEIVER
};
enum SIPCType {
 Sipc_sysv_shm     = SIPC_SYSV_SHM,
 Sipc_sysv_mqueues = SIPC_SYSV_MQUEUES,
 Sipc_num_types    = SIPC_NUM_TYPES
};
enum SIPCIOCtl {
 Sipc_block   = SIPC_BLOCK,
 Sipc_noblock = SIPC_NOBLOCK
};
#endc

-- |SIPC Roles
{#enum SIPCRole {} deriving (Eq, Show)#}
-- |SIPC Types
{#enum SIPCType {} deriving (Eq, Show)#}
-- |SIPC behaviors, for sipc_ioctl()
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
