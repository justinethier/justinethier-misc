module SIPC
where

-- import Monad
--import C2HS

#c
enum SIPCType {
 sipc_sysv_shm     = SIPC_SYSV_SHM,
 sipc_sysv_mqueues = SIPC_SYSV_MQUEUES,
 sipc_num_types    = SIPC_NUM_TYPES
};
#endc
{#enum SIPCType {}#}

{#fun sipc_unlink {`String', `Int'} -> `()' #}

