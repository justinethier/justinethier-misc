{-# LANGUAGE CPP, ForeignFunctionInterface #-}

module Sipc where

import Foreign
import Foreign.C.Types

#include <sipc/sipc.h>

-- |SIPC Roles
newtype SIPCRole = SIPCRole { unSIPCRole :: CInt } deriving (Eq, Show)
#{enum SIPCType, SIPCType
 , sipc_creator  = SIPC_CREATOR
 , sipc_sender   = SIPC_SENDER
 , sipc_receiver = SIPC_RECEIVER
 }

-- |SIPC Types
newtype SIPCType = SIPCType { unSIPCType :: CInt }  deriving (Eq, Show) 
#{enum SIPCType, SIPCType
 , sipc_sysv_shm     = SIPC_SYSV_SHM
 , sipc_sysv_mqueues = SIPC_SYSV_MQUEUES
 , sipc_num_types    = SIPC_NUM_TYPES
 }

-- |SIPC behaviors, for sipc_ioctl()
newtype SIPCIOCtl = SIPCIOCtl { unSIPCIOCtl :: CInt }  deriving (Eq, Show) 
#{enum SIPCIOCtl, SIPCIOCtl
 , sipc_block   = SIPC_BLOCK
 , sipc_noblock = SIPC_NOBLOCK
 }

