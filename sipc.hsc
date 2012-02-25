{-# LANGUAGE CPP, ForeignFunctionInterface #-}

module Sipc where

import Foreign
import Foreign.C.Types

#include <sipc/sipc.h>

newtype SIPCRole = SIPCRole { unSIPCRole :: CInt } deriving (Eq, Show)
newtype SIPCType = SIPCType { unSIPCType :: CInt }  deriving (Eq, Show) 
newtype SIPCIOCtl = SIPCIOCtl { unSIPCIOCtl :: CInt }  deriving (Eq, Show) 

sipc_creator, sipc_sender, sipc_receiver :: SIPCRole
sipc_creator = SIPCRole #const SIPC_CREATOR
sipc_sender = SIPCRole #const SIPC_SENDER
sipc_receiver = SIPCRole #const SIPC_RECEIVER

sipc_sysv_shm, sipc_sysv_mqueues, sipc_num_types :: SIPCType
sipc_sysv_shm = SIPCType #const SIPC_SYSV_SHM
sipc_sysv_mqueues = SIPCType #const SIPC_SYSV_MQUEUES
sipc_num_types = SIPCType #const SIPC_NUM_TYPES

sipc_block, sipc_noblock :: SIPCIOCtl
sipc_block = SIPCIOCtl #const SIPC_BLOCK
sipc_noblock = SIPCIOCtl #const SIPC_NOBLOCK

