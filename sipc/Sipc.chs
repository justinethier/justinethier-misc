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

-- TODO: documentation for *everything* once all defs are in place

--data Sipc = Sipc 
--type SipcPtr = Ptr Sipc 
type SipcPtr = Ptr ()

-- TODO: CSize for last input arg?
{#fun unsafe sipc_open {`String', _cFromEnum `SIPCRole', _cFromEnum `SIPCType', `Int' } -> `SipcPtr' id #}
{#fun unsafe sipc_close {id `SipcPtr'} -> `()' #}

{#fun sipc_unlink {`String', _cFromEnum `SIPCType'} -> `()' #}

{- TODO:

-- return type is allocated and must be freed by sipc_close
-- believe we need to indicate the alloc to Haskell somehow?
sipc_t *sipc_open(const char *key, int role, int ipc_type, size_t size);
void sipc_close(sipc_t *sipc);




int sipc_ioctl(sipc_t *sipc, int request);
int sipc_send_data(sipc_t *sipc, size_t msg_len);

-- data is allocated by C, believe this must be indicated to Haskell
-- TBD: what about len??
int sipc_recv_data(sipc_t *sipc, char **data, size_t *len);

/* Returns a pointer to the data contained within the IPC resource */
char *sipc_get_data_ptr(sipc_t *sipc);

-- TODO: are variable-length args even supported by the Haskell FFI???
/* Prints an error message, accepts printf format string */
void sipc_error(sipc_t *sipc, const char *fmt, ...)
	__attribute__ ((format(printf, 2, 3)));

int sipc_shm_recv_done(sipc_t *sipc);
-}

-- |Convert a Haskell enumeration to C.
--
--  Explicitly added to this module since this function
--  is deprecated from C2HS.
_cFromEnum :: (Enum e, Integral i) => e -> i
_cFromEnum  = fromIntegral . fromEnum


-- Only here because of how the test file is structured
main :: IO ()
main = do
  sipc <- sipc_open "sipc_mq_test" Sipc_creator Sipc_sysv_mqueues 0
  -- TODO: now to test for NULL pointer?
  sipc_close(sipc)
  putStrLn ""
