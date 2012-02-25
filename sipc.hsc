{-# LANGUAGE CPP, ForeignFunctionInterface #-}

module Sipc where

import Foreign
import Foreign.C.Types

#include "sipc.h"

newtype SIPCRole = SIPCRole { unSIPCRole :: CInt } deriving (Eq, Show)

sipc_creator, sipc_sender, sipc_receiver :: SIPCRole
sipc_creator = SIPCRole #const SIPC_CREATOR
sipc_sender = SIPCRole #const SIPC_SENDER
sipc_receiver = SIPCRole #const SIPC_RECEIVER


