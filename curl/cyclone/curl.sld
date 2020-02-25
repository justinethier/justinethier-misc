(define-library (cyclone curl)
  (include-c-header "<curl/curl.h>")
  (export 
    curl-global-init
    curl-easy-init
    curl-easy-cleanup
    curl-easy-setopt
    curl-easy-perform
    curl-version

    ; CURLOPT_ABSTRACT_UNIX_SOCKET
    CURLOPT_ACCEPTTIMEOUT_MS
    CURLOPT_ACCEPT_ENCODING
    CURLOPT_ADDRESS_SCOPE
    ; CURLOPT_ALTSVC
    ; CURLOPT_ALTSVC_CTRL
    CURLOPT_APPEND
    CURLOPT_AUTOREFERER
    CURLOPT_BUFFERSIZE
    CURLOPT_CAINFO
    CURLOPT_CAPATH
    CURLOPT_CERTINFO
    CURLOPT_CHUNK_BGN_FUNCTION
    CURLOPT_CHUNK_DATA
    CURLOPT_CHUNK_END_FUNCTION
    CURLOPT_CLOSESOCKETDATA
    CURLOPT_CLOSESOCKETFUNCTION
    CURLOPT_CONNECTTIMEOUT
    CURLOPT_CONNECTTIMEOUT_MS
    CURLOPT_CONNECT_ONLY
    ; CURLOPT_CONNECT_TO
    CURLOPT_CONV_FROM_NETWORK_FUNCTION
    CURLOPT_CONV_FROM_UTF8_FUNCTION
    CURLOPT_CONV_TO_NETWORK_FUNCTION
    CURLOPT_COOKIE
    CURLOPT_COOKIEFILE
    CURLOPT_COOKIEJAR
    CURLOPT_COOKIELIST
    CURLOPT_COOKIESESSION
    CURLOPT_COPYPOSTFIELDS
    CURLOPT_CRLF
    CURLOPT_CRLFILE
    ; CURLOPT_CURLU
    CURLOPT_CUSTOMREQUEST
    CURLOPT_DEBUGDATA
    CURLOPT_DEBUGFUNCTION
    CURLOPT_DEFAULT_PROTOCOL
    CURLOPT_DIRLISTONLY
    ; CURLOPT_DISALLOW_USERNAME_IN_URL
    CURLOPT_DNS_CACHE_TIMEOUT
    CURLOPT_DNS_INTERFACE
    CURLOPT_DNS_LOCAL_IP4
    CURLOPT_DNS_LOCAL_IP6
    CURLOPT_DNS_SERVERS
    ; CURLOPT_DNS_SHUFFLE_ADDRESSES
    CURLOPT_DNS_USE_GLOBAL_CACHE
    ; CURLOPT_DOH_URL
    CURLOPT_EGDSOCKET
    CURLOPT_ERRORBUFFER
    CURLOPT_EXPECT_100_TIMEOUT_MS
    CURLOPT_FAILONERROR
    CURLOPT_FILETIME
    CURLOPT_FNMATCH_DATA
    CURLOPT_FNMATCH_FUNCTION
    CURLOPT_FOLLOWLOCATION
    CURLOPT_FORBID_REUSE
    CURLOPT_FRESH_CONNECT
    CURLOPT_FTPPORT
    CURLOPT_FTPSSLAUTH
    CURLOPT_FTP_ACCOUNT
    CURLOPT_FTP_ALTERNATIVE_TO_USER
    CURLOPT_FTP_CREATE_MISSING_DIRS
    CURLOPT_FTP_FILEMETHOD
    CURLOPT_FTP_RESPONSE_TIMEOUT
    CURLOPT_FTP_SKIP_PASV_IP
    CURLOPT_FTP_SSL_CCC
    CURLOPT_FTP_USE_EPRT
    CURLOPT_FTP_USE_EPSV
    CURLOPT_FTP_USE_PRET
    CURLOPT_GSSAPI_DELEGATION
    ; CURLOPT_HAPPY_EYEBALLS_TIMEOUT_MS
    ; CURLOPT_HAPROXYPROTOCOL
    CURLOPT_HEADER
    CURLOPT_HEADERDATA
    CURLOPT_HEADERFUNCTION
    CURLOPT_HEADEROPT
    ; CURLOPT_HTTP09_ALLOWED
    CURLOPT_HTTP200ALIASES
    CURLOPT_HTTPAUTH
    CURLOPT_HTTPGET
    CURLOPT_HTTPHEADER
    CURLOPT_HTTPPOST
    CURLOPT_HTTPPROXYTUNNEL
    CURLOPT_HTTP_CONTENT_DECODING
    CURLOPT_HTTP_TRANSFER_DECODING
    CURLOPT_HTTP_VERSION
    CURLOPT_IGNORE_CONTENT_LENGTH
    CURLOPT_INFILESIZE
    CURLOPT_INFILESIZE_LARGE
    CURLOPT_INTERFACE
    CURLOPT_INTERLEAVEDATA
    CURLOPT_INTERLEAVEFUNCTION
    CURLOPT_IOCTLDATA
    CURLOPT_IOCTLFUNCTION
    CURLOPT_IPRESOLVE
    CURLOPT_ISSUERCERT
    ;CURLOPT_KEEP_SENDING_ON_ERROR
    CURLOPT_KEYPASSWD
    CURLOPT_KRBLEVEL
    CURLOPT_LOCALPORT
    CURLOPT_LOCALPORTRANGE
    CURLOPT_LOGIN_OPTIONS
    CURLOPT_LOW_SPEED_LIMIT
    CURLOPT_LOW_SPEED_TIME
    CURLOPT_MAIL_AUTH
    CURLOPT_MAIL_FROM
    CURLOPT_MAIL_RCPT
    ; CURLOPT_MAIL_RCPT_ALLLOWFAILS
    ; CURLOPT_MAXAGE_CONN
    CURLOPT_MAXCONNECTS
    CURLOPT_MAXFILESIZE
    CURLOPT_MAXFILESIZE_LARGE
    CURLOPT_MAXREDIRS
    CURLOPT_MAX_RECV_SPEED_LARGE
    CURLOPT_MAX_SEND_SPEED_LARGE
    ; CURLOPT_MIMEPOST
    CURLOPT_NETRC
    CURLOPT_NETRC_FILE
    CURLOPT_NEW_DIRECTORY_PERMS
    CURLOPT_NEW_FILE_PERMS
    CURLOPT_NOBODY
    CURLOPT_NOPROGRESS
    CURLOPT_NOPROXY
    CURLOPT_NOSIGNAL
    CURLOPT_OPENSOCKETDATA
    CURLOPT_OPENSOCKETFUNCTION
    CURLOPT_PASSWORD
    CURLOPT_PATH_AS_IS
    CURLOPT_PINNEDPUBLICKEY
    CURLOPT_PIPEWAIT
    CURLOPT_PORT
    CURLOPT_POST
    CURLOPT_POSTFIELDS
    CURLOPT_POSTFIELDSIZE
    CURLOPT_POSTFIELDSIZE_LARGE
    CURLOPT_POSTQUOTE
    CURLOPT_POSTREDIR
    CURLOPT_PREQUOTE
    ; CURLOPT_PRE_PROXY
    CURLOPT_PRIVATE
    CURLOPT_PROGRESSDATA
    CURLOPT_PROGRESSFUNCTION
    CURLOPT_PROTOCOLS
    CURLOPT_PROXY
    CURLOPT_PROXYAUTH
    CURLOPT_PROXYHEADER
    CURLOPT_PROXYPASSWORD
    CURLOPT_PROXYPORT
    CURLOPT_PROXYTYPE
    CURLOPT_PROXYUSERNAME
    CURLOPT_PROXYUSERPWD
    ; CURLOPT_PROXY_CAINFO
    ; CURLOPT_PROXY_CAPATH
    ; CURLOPT_PROXY_CRLFILE
    ; CURLOPT_PROXY_KEYPASSWD
    ; CURLOPT_PROXY_PINNEDPUBLICKEY
    CURLOPT_PROXY_SERVICE_NAME
    ; CURLOPT_PROXY_SSLCERT
    ; CURLOPT_PROXY_SSLCERTTYPE
    ; CURLOPT_PROXY_SSLKEY
    ; CURLOPT_PROXY_SSLKEYTYPE
    ; CURLOPT_PROXY_SSLVERSION
    ; CURLOPT_PROXY_SSL_CIPHER_LIST
    ; CURLOPT_PROXY_SSL_OPTIONS
    ; CURLOPT_PROXY_SSL_VERIFYHOST
    ; CURLOPT_PROXY_SSL_VERIFYPEER
    ; CURLOPT_PROXY_TLS13_CIPHERS
    ; CURLOPT_PROXY_TLSAUTH_PASSWORD
    ; CURLOPT_PROXY_TLSAUTH_TYPE
    ; CURLOPT_PROXY_TLSAUTH_USERNAME
    CURLOPT_PROXY_TRANSFER_MODE
    CURLOPT_PUT
    CURLOPT_QUOTE
    CURLOPT_RANDOM_FILE
    CURLOPT_RANGE
    CURLOPT_READDATA
    CURLOPT_READFUNCTION
    CURLOPT_REDIR_PROTOCOLS
    CURLOPT_REFERER
    ; CURLOPT_REQUEST_TARGET
    CURLOPT_RESOLVE
    ; CURLOPT_RESOLVER_START_DATA
    ; CURLOPT_RESOLVER_START_FUNCTION
    CURLOPT_RESUME_FROM
    CURLOPT_RESUME_FROM_LARGE
    CURLOPT_RTSP_CLIENT_CSEQ
    CURLOPT_RTSP_REQUEST
    CURLOPT_RTSP_SERVER_CSEQ
    CURLOPT_RTSP_SESSION_ID
    CURLOPT_RTSP_STREAM_URI
    CURLOPT_RTSP_TRANSPORT
    ; CURLOPT_SASL_AUTHZID
    CURLOPT_SASL_IR
    CURLOPT_SEEKDATA
    CURLOPT_SEEKFUNCTION
    CURLOPT_SERVICE_NAME
    CURLOPT_SHARE
    CURLOPT_SOCKOPTDATA
    CURLOPT_SOCKOPTFUNCTION
    ; CURLOPT_SOCKS5_AUTH
    CURLOPT_SOCKS5_GSSAPI_NEC
    CURLOPT_SOCKS5_GSSAPI_SERVICE
    CURLOPT_SSH_AUTH_TYPES
    ; CURLOPT_SSH_COMPRESSION
    CURLOPT_SSH_HOST_PUBLIC_KEY_MD5
    CURLOPT_SSH_KEYDATA
    CURLOPT_SSH_KEYFUNCTION
    CURLOPT_SSH_KNOWNHOSTS
    CURLOPT_SSH_PRIVATE_KEYFILE
    CURLOPT_SSH_PUBLIC_KEYFILE
    CURLOPT_SSLCERT
    CURLOPT_SSLCERTTYPE
    CURLOPT_SSLENGINE
    CURLOPT_SSLENGINE_DEFAULT
    CURLOPT_SSLKEY
    CURLOPT_SSLKEYTYPE
    CURLOPT_SSLVERSION
    CURLOPT_SSL_CIPHER_LIST
    CURLOPT_SSL_CTX_DATA
    CURLOPT_SSL_CTX_FUNCTION
    CURLOPT_SSL_ENABLE_ALPN
    CURLOPT_SSL_ENABLE_NPN
    CURLOPT_SSL_FALSESTART
    CURLOPT_SSL_OPTIONS
    CURLOPT_SSL_SESSIONID_CACHE
    CURLOPT_SSL_VERIFYHOST
    CURLOPT_SSL_VERIFYPEER
    CURLOPT_SSL_VERIFYSTATUS
    CURLOPT_STDERR
    CURLOPT_STREAM_DEPENDS
    CURLOPT_STREAM_DEPENDS_E
    CURLOPT_STREAM_WEIGHT
    ; CURLOPT_SUPPRESS_CONNECT_HEADERS
    ; CURLOPT_TCP_FASTOPEN
    CURLOPT_TCP_KEEPALIVE
    CURLOPT_TCP_KEEPIDLE
    CURLOPT_TCP_KEEPINTVL
    CURLOPT_TCP_NODELAY
    CURLOPT_TELNETOPTIONS
    CURLOPT_TFTP_BLKSIZE
    ; CURLOPT_TFTP_NO_OPTIONS
    CURLOPT_TIMECONDITION
    CURLOPT_TIMEOUT
    CURLOPT_TIMEOUT_MS
    CURLOPT_TIMEVALUE
    ;CURLOPT_TIMEVALUE_LARGE
    ;CURLOPT_TLS13_CIPHERS
    CURLOPT_TLSAUTH_PASSWORD
    CURLOPT_TLSAUTH_TYPE
    CURLOPT_TLSAUTH_USERNAME
    ; CURLOPT_TRAILERDATA
    ; CURLOPT_TRAILERFUNCTION
    CURLOPT_TRANSFERTEXT
    CURLOPT_TRANSFER_ENCODING
    CURLOPT_UNIX_SOCKET_PATH
    CURLOPT_UNRESTRICTED_AUTH
    ; CURLOPT_UPKEEP_INTERVAL_MS
    CURLOPT_UPLOAD
    ; CURLOPT_UPLOAD_BUFFERSIZE
    CURLOPT_URL
    CURLOPT_USERAGENT
    CURLOPT_USERNAME
    CURLOPT_USERPWD
    CURLOPT_USE_SSL
    CURLOPT_VERBOSE
    CURLOPT_WILDCARDMATCH
    CURLOPT_WRITEDATA
    CURLOPT_WRITEFUNCTION
    CURLOPT_XFERINFODATA
    CURLOPT_XFERINFOFUNCTION
    CURLOPT_XOAUTH2_BEARER
  )
  (c-linker-options "-lcurl")
  ;(import (scheme base)
  ;        (scheme write)
  ;)
  (begin

    (define-syntax define-curl-const
      (er-macro-transformer
        (lambda (expr rename compare)
          (let* ((sym (cadr expr))
                 (str (symbol->string sym))
                 (lib_fnc_str (string-append "_" str))
                 (lib_fnc (string->symbol lib_fnc_str)) ;; Internal library function
                 (args "(void *data, int argc, closure _, object k)")
                 (body
                   (string-append
                     "return_closcall1(data, k, obj_int2obj(" str "));"))
                )
          `(begin
            (define-c ,lib_fnc ,args ,body)
            (define ,sym (,lib_fnc))
            )))))

    ;(define-curl-const CURLOPT_ABSTRACT_UNIX_SOCKET)
    (define-curl-const CURLOPT_ACCEPTTIMEOUT_MS)
    (define-curl-const CURLOPT_ACCEPT_ENCODING)
    (define-curl-const CURLOPT_ADDRESS_SCOPE)
    ;(define-curl-const CURLOPT_ALTSVC)
    ;(define-curl-const CURLOPT_ALTSVC_CTRL)
    (define-curl-const CURLOPT_APPEND)
    (define-curl-const CURLOPT_AUTOREFERER)
    (define-curl-const CURLOPT_BUFFERSIZE)
    (define-curl-const CURLOPT_CAINFO)
    (define-curl-const CURLOPT_CAPATH)
    (define-curl-const CURLOPT_CERTINFO)
    (define-curl-const CURLOPT_CHUNK_BGN_FUNCTION)
    (define-curl-const CURLOPT_CHUNK_DATA)
    (define-curl-const CURLOPT_CHUNK_END_FUNCTION)
    (define-curl-const CURLOPT_CLOSESOCKETDATA)
    (define-curl-const CURLOPT_CLOSESOCKETFUNCTION)
    (define-curl-const CURLOPT_CONNECTTIMEOUT)
    (define-curl-const CURLOPT_CONNECTTIMEOUT_MS)
    (define-curl-const CURLOPT_CONNECT_ONLY)
    ;(define-curl-const CURLOPT_CONNECT_TO)
    (define-curl-const CURLOPT_CONV_FROM_NETWORK_FUNCTION)
    (define-curl-const CURLOPT_CONV_FROM_UTF8_FUNCTION)
    (define-curl-const CURLOPT_CONV_TO_NETWORK_FUNCTION)
    (define-curl-const CURLOPT_COOKIE)
    (define-curl-const CURLOPT_COOKIEFILE)
    (define-curl-const CURLOPT_COOKIEJAR)
    (define-curl-const CURLOPT_COOKIELIST)
    (define-curl-const CURLOPT_COOKIESESSION)
    (define-curl-const CURLOPT_COPYPOSTFIELDS)
    (define-curl-const CURLOPT_CRLF)
    (define-curl-const CURLOPT_CRLFILE)
    ;(define-curl-const CURLOPT_CURLU)
    (define-curl-const CURLOPT_CUSTOMREQUEST)
    (define-curl-const CURLOPT_DEBUGDATA)
    (define-curl-const CURLOPT_DEBUGFUNCTION)
    (define-curl-const CURLOPT_DEFAULT_PROTOCOL)
    (define-curl-const CURLOPT_DIRLISTONLY)
    ;(define-curl-const CURLOPT_DISALLOW_USERNAME_IN_URL)
    (define-curl-const CURLOPT_DNS_CACHE_TIMEOUT)
    (define-curl-const CURLOPT_DNS_INTERFACE)
    (define-curl-const CURLOPT_DNS_LOCAL_IP4)
    (define-curl-const CURLOPT_DNS_LOCAL_IP6)
    (define-curl-const CURLOPT_DNS_SERVERS)
    ;(define-curl-const CURLOPT_DNS_SHUFFLE_ADDRESSES)
    (define-curl-const CURLOPT_DNS_USE_GLOBAL_CACHE)
    ;(define-curl-const CURLOPT_DOH_URL)
    (define-curl-const CURLOPT_EGDSOCKET)
    (define-curl-const CURLOPT_ERRORBUFFER)
    (define-curl-const CURLOPT_EXPECT_100_TIMEOUT_MS)
    (define-curl-const CURLOPT_FAILONERROR)
    (define-curl-const CURLOPT_FILETIME)
    (define-curl-const CURLOPT_FNMATCH_DATA)
    (define-curl-const CURLOPT_FNMATCH_FUNCTION)
    (define-curl-const CURLOPT_FOLLOWLOCATION)
    (define-curl-const CURLOPT_FORBID_REUSE)
    (define-curl-const CURLOPT_FRESH_CONNECT)
    (define-curl-const CURLOPT_FTPPORT)
    (define-curl-const CURLOPT_FTPSSLAUTH)
    (define-curl-const CURLOPT_FTP_ACCOUNT)
    (define-curl-const CURLOPT_FTP_ALTERNATIVE_TO_USER)
    (define-curl-const CURLOPT_FTP_CREATE_MISSING_DIRS)
    (define-curl-const CURLOPT_FTP_FILEMETHOD)
    (define-curl-const CURLOPT_FTP_RESPONSE_TIMEOUT)
    (define-curl-const CURLOPT_FTP_SKIP_PASV_IP)
    (define-curl-const CURLOPT_FTP_SSL_CCC)
    (define-curl-const CURLOPT_FTP_USE_EPRT)
    (define-curl-const CURLOPT_FTP_USE_EPSV)
    (define-curl-const CURLOPT_FTP_USE_PRET)
    (define-curl-const CURLOPT_GSSAPI_DELEGATION)
    ;(define-curl-const CURLOPT_HAPPY_EYEBALLS_TIMEOUT_MS)
    ;(define-curl-const CURLOPT_HAPROXYPROTOCOL)
    (define-curl-const CURLOPT_HEADER)
    (define-curl-const CURLOPT_HEADERDATA)
    (define-curl-const CURLOPT_HEADERFUNCTION)
    (define-curl-const CURLOPT_HEADEROPT)
    ;(define-curl-const CURLOPT_HTTP09_ALLOWED)
    (define-curl-const CURLOPT_HTTP200ALIASES)
    (define-curl-const CURLOPT_HTTPAUTH)
    (define-curl-const CURLOPT_HTTPGET)
    (define-curl-const CURLOPT_HTTPHEADER)
    (define-curl-const CURLOPT_HTTPPOST)
    (define-curl-const CURLOPT_HTTPPROXYTUNNEL)
    (define-curl-const CURLOPT_HTTP_CONTENT_DECODING)
    (define-curl-const CURLOPT_HTTP_TRANSFER_DECODING)
    (define-curl-const CURLOPT_HTTP_VERSION)
    (define-curl-const CURLOPT_IGNORE_CONTENT_LENGTH)
    (define-curl-const CURLOPT_INFILESIZE)
    (define-curl-const CURLOPT_INFILESIZE_LARGE)
    (define-curl-const CURLOPT_INTERFACE)
    (define-curl-const CURLOPT_INTERLEAVEDATA)
    (define-curl-const CURLOPT_INTERLEAVEFUNCTION)
    (define-curl-const CURLOPT_IOCTLDATA)
    (define-curl-const CURLOPT_IOCTLFUNCTION)
    (define-curl-const CURLOPT_IPRESOLVE)
    (define-curl-const CURLOPT_ISSUERCERT)
    ;(define-curl-const CURLOPT_KEEP_SENDING_ON_ERROR)
    (define-curl-const CURLOPT_KEYPASSWD)
    (define-curl-const CURLOPT_KRBLEVEL)
    (define-curl-const CURLOPT_LOCALPORT)
    (define-curl-const CURLOPT_LOCALPORTRANGE)
    (define-curl-const CURLOPT_LOGIN_OPTIONS)
    (define-curl-const CURLOPT_LOW_SPEED_LIMIT)
    (define-curl-const CURLOPT_LOW_SPEED_TIME)
    (define-curl-const CURLOPT_MAIL_AUTH)
    (define-curl-const CURLOPT_MAIL_FROM)
    (define-curl-const CURLOPT_MAIL_RCPT)
    ;(define-curl-const CURLOPT_MAIL_RCPT_ALLLOWFAILS)
    ;(define-curl-const CURLOPT_MAXAGE_CONN)
    (define-curl-const CURLOPT_MAXCONNECTS)
    (define-curl-const CURLOPT_MAXFILESIZE)
    (define-curl-const CURLOPT_MAXFILESIZE_LARGE)
    (define-curl-const CURLOPT_MAXREDIRS)
    (define-curl-const CURLOPT_MAX_RECV_SPEED_LARGE)
    (define-curl-const CURLOPT_MAX_SEND_SPEED_LARGE)
    ;(define-curl-const CURLOPT_MIMEPOST)
    (define-curl-const CURLOPT_NETRC)
    (define-curl-const CURLOPT_NETRC_FILE)
    (define-curl-const CURLOPT_NEW_DIRECTORY_PERMS)
    (define-curl-const CURLOPT_NEW_FILE_PERMS)
    (define-curl-const CURLOPT_NOBODY)
    (define-curl-const CURLOPT_NOPROGRESS)
    (define-curl-const CURLOPT_NOPROXY)
    (define-curl-const CURLOPT_NOSIGNAL)
    (define-curl-const CURLOPT_OPENSOCKETDATA)
    (define-curl-const CURLOPT_OPENSOCKETFUNCTION)
    (define-curl-const CURLOPT_PASSWORD)
    (define-curl-const CURLOPT_PATH_AS_IS)
    (define-curl-const CURLOPT_PINNEDPUBLICKEY)
    (define-curl-const CURLOPT_PIPEWAIT)
    (define-curl-const CURLOPT_PORT)
    (define-curl-const CURLOPT_POST)
    (define-curl-const CURLOPT_POSTFIELDS)
    (define-curl-const CURLOPT_POSTFIELDSIZE)
    (define-curl-const CURLOPT_POSTFIELDSIZE_LARGE)
    (define-curl-const CURLOPT_POSTQUOTE)
    (define-curl-const CURLOPT_POSTREDIR)
    (define-curl-const CURLOPT_PREQUOTE)
    ;(define-curl-const CURLOPT_PRE_PROXY)
    (define-curl-const CURLOPT_PRIVATE)
    (define-curl-const CURLOPT_PROGRESSDATA)
    (define-curl-const CURLOPT_PROGRESSFUNCTION)
    (define-curl-const CURLOPT_PROTOCOLS)
    (define-curl-const CURLOPT_PROXY)
    (define-curl-const CURLOPT_PROXYAUTH)
    (define-curl-const CURLOPT_PROXYHEADER)
    (define-curl-const CURLOPT_PROXYPASSWORD)
    (define-curl-const CURLOPT_PROXYPORT)
    (define-curl-const CURLOPT_PROXYTYPE)
    (define-curl-const CURLOPT_PROXYUSERNAME)
    (define-curl-const CURLOPT_PROXYUSERPWD)
    ;(define-curl-const CURLOPT_PROXY_CAINFO)
    ;(define-curl-const CURLOPT_PROXY_CAPATH)
    ;(define-curl-const CURLOPT_PROXY_CRLFILE)
    ;(define-curl-const CURLOPT_PROXY_KEYPASSWD)
    ;(define-curl-const CURLOPT_PROXY_PINNEDPUBLICKEY)
    (define-curl-const CURLOPT_PROXY_SERVICE_NAME)
    ;(define-curl-const CURLOPT_PROXY_SSLCERT)
    ;(define-curl-const CURLOPT_PROXY_SSLCERTTYPE)
    ;(define-curl-const CURLOPT_PROXY_SSLKEY)
    ;(define-curl-const CURLOPT_PROXY_SSLKEYTYPE)
    ;(define-curl-const CURLOPT_PROXY_SSLVERSION)
    ;(define-curl-const CURLOPT_PROXY_SSL_CIPHER_LIST)
    ;(define-curl-const CURLOPT_PROXY_SSL_OPTIONS)
    ;(define-curl-const CURLOPT_PROXY_SSL_VERIFYHOST)
    ;(define-curl-const CURLOPT_PROXY_SSL_VERIFYPEER)
    ;(define-curl-const CURLOPT_PROXY_TLS13_CIPHERS)
    ;(define-curl-const CURLOPT_PROXY_TLSAUTH_PASSWORD)
    ;(define-curl-const CURLOPT_PROXY_TLSAUTH_TYPE)
    ;(define-curl-const CURLOPT_PROXY_TLSAUTH_USERNAME)
    (define-curl-const CURLOPT_PROXY_TRANSFER_MODE)
    (define-curl-const CURLOPT_PUT)
    (define-curl-const CURLOPT_QUOTE)
    (define-curl-const CURLOPT_RANDOM_FILE)
    (define-curl-const CURLOPT_RANGE)
    (define-curl-const CURLOPT_READDATA)
    (define-curl-const CURLOPT_READFUNCTION)
    (define-curl-const CURLOPT_REDIR_PROTOCOLS)
    (define-curl-const CURLOPT_REFERER)
    ;(define-curl-const CURLOPT_REQUEST_TARGET)
    (define-curl-const CURLOPT_RESOLVE)
    ;(define-curl-const CURLOPT_RESOLVER_START_DATA)
    ;(define-curl-const CURLOPT_RESOLVER_START_FUNCTION)
    (define-curl-const CURLOPT_RESUME_FROM)
    (define-curl-const CURLOPT_RESUME_FROM_LARGE)
    (define-curl-const CURLOPT_RTSP_CLIENT_CSEQ)
    (define-curl-const CURLOPT_RTSP_REQUEST)
    (define-curl-const CURLOPT_RTSP_SERVER_CSEQ)
    (define-curl-const CURLOPT_RTSP_SESSION_ID)
    (define-curl-const CURLOPT_RTSP_STREAM_URI)
    (define-curl-const CURLOPT_RTSP_TRANSPORT)
    ;(define-curl-const CURLOPT_SASL_AUTHZID)
    (define-curl-const CURLOPT_SASL_IR)
    (define-curl-const CURLOPT_SEEKDATA)
    (define-curl-const CURLOPT_SEEKFUNCTION)
    (define-curl-const CURLOPT_SERVICE_NAME)
    (define-curl-const CURLOPT_SHARE)
    (define-curl-const CURLOPT_SOCKOPTDATA)
    (define-curl-const CURLOPT_SOCKOPTFUNCTION)
    ;(define-curl-const CURLOPT_SOCKS5_AUTH)
    (define-curl-const CURLOPT_SOCKS5_GSSAPI_NEC)
    (define-curl-const CURLOPT_SOCKS5_GSSAPI_SERVICE)
    (define-curl-const CURLOPT_SSH_AUTH_TYPES)
    ;(define-curl-const CURLOPT_SSH_COMPRESSION)
    (define-curl-const CURLOPT_SSH_HOST_PUBLIC_KEY_MD5)
    (define-curl-const CURLOPT_SSH_KEYDATA)
    (define-curl-const CURLOPT_SSH_KEYFUNCTION)
    (define-curl-const CURLOPT_SSH_KNOWNHOSTS)
    (define-curl-const CURLOPT_SSH_PRIVATE_KEYFILE)
    (define-curl-const CURLOPT_SSH_PUBLIC_KEYFILE)
    (define-curl-const CURLOPT_SSLCERT)
    (define-curl-const CURLOPT_SSLCERTTYPE)
    (define-curl-const CURLOPT_SSLENGINE)
    (define-curl-const CURLOPT_SSLENGINE_DEFAULT)
    (define-curl-const CURLOPT_SSLKEY)
    (define-curl-const CURLOPT_SSLKEYTYPE)
    (define-curl-const CURLOPT_SSLVERSION)
    (define-curl-const CURLOPT_SSL_CIPHER_LIST)
    (define-curl-const CURLOPT_SSL_CTX_DATA)
    (define-curl-const CURLOPT_SSL_CTX_FUNCTION)
    (define-curl-const CURLOPT_SSL_ENABLE_ALPN)
    (define-curl-const CURLOPT_SSL_ENABLE_NPN)
    (define-curl-const CURLOPT_SSL_FALSESTART)
    (define-curl-const CURLOPT_SSL_OPTIONS)
    (define-curl-const CURLOPT_SSL_SESSIONID_CACHE)
    (define-curl-const CURLOPT_SSL_VERIFYHOST)
    (define-curl-const CURLOPT_SSL_VERIFYPEER)
    (define-curl-const CURLOPT_SSL_VERIFYSTATUS)
    (define-curl-const CURLOPT_STDERR)
    (define-curl-const CURLOPT_STREAM_DEPENDS)
    (define-curl-const CURLOPT_STREAM_DEPENDS_E)
    (define-curl-const CURLOPT_STREAM_WEIGHT)
    ;(define-curl-const CURLOPT_SUPPRESS_CONNECT_HEADERS)
    ;(define-curl-const CURLOPT_TCP_FASTOPEN)
    (define-curl-const CURLOPT_TCP_KEEPALIVE)
    (define-curl-const CURLOPT_TCP_KEEPIDLE)
    (define-curl-const CURLOPT_TCP_KEEPINTVL)
    (define-curl-const CURLOPT_TCP_NODELAY)
    (define-curl-const CURLOPT_TELNETOPTIONS)
    (define-curl-const CURLOPT_TFTP_BLKSIZE)
    ;(define-curl-const CURLOPT_TFTP_NO_OPTIONS)
    (define-curl-const CURLOPT_TIMECONDITION)
    (define-curl-const CURLOPT_TIMEOUT)
    (define-curl-const CURLOPT_TIMEOUT_MS)
    (define-curl-const CURLOPT_TIMEVALUE)
    ;(define-curl-const CURLOPT_TIMEVALUE_LARGE)
    ;(define-curl-const CURLOPT_TLS13_CIPHERS)
    (define-curl-const CURLOPT_TLSAUTH_PASSWORD)
    (define-curl-const CURLOPT_TLSAUTH_TYPE)
    (define-curl-const CURLOPT_TLSAUTH_USERNAME)
    ;(define-curl-const CURLOPT_TRAILERDATA)
    ;(define-curl-const CURLOPT_TRAILERFUNCTION)
    (define-curl-const CURLOPT_TRANSFERTEXT)
    (define-curl-const CURLOPT_TRANSFER_ENCODING)
    (define-curl-const CURLOPT_UNIX_SOCKET_PATH)
    (define-curl-const CURLOPT_UNRESTRICTED_AUTH)
    ;(define-curl-const CURLOPT_UPKEEP_INTERVAL_MS)
    (define-curl-const CURLOPT_UPLOAD)
    ;(define-curl-const CURLOPT_UPLOAD_BUFFERSIZE)
    (define-curl-const CURLOPT_URL)
    (define-curl-const CURLOPT_USERAGENT)
    (define-curl-const CURLOPT_USERNAME)
    (define-curl-const CURLOPT_USERPWD)
    (define-curl-const CURLOPT_USE_SSL)
    (define-curl-const CURLOPT_VERBOSE)
    (define-curl-const CURLOPT_WILDCARDMATCH)
    (define-curl-const CURLOPT_WRITEDATA)
    (define-curl-const CURLOPT_WRITEFUNCTION)
    (define-curl-const CURLOPT_XFERINFODATA)
    (define-curl-const CURLOPT_XFERINFOFUNCTION)
    (define-curl-const CURLOPT_XOAUTH2_BEARER)

    (define-c curl-version
      "(void *data, int argc, closure _, object k)"
      "char *version = curl_version();
       make_string(scm_version, version);
       return_closcall1(data, k, &scm_version); ")

    (define-c curl-global-init
      "(void *data, int argc, closure _, object k, object flags)"
      " CURLcode result = curl_global_init(obj_obj2int(flags));
        return_closcall1(data, k, obj_int2obj(result)); ")

    (define-c curl-easy-init
      "(void *data, int argc, closure _, object k)"
      " CURL *curl = curl_easy_init();
        if (curl) {
          make_c_opaque(opq, curl);
          return_closcall1(data, k, &opq); 
        } else {
          return_closcall1(data, k, boolean_f); 
        } ")

    (define-c curl-easy-cleanup
      "(void *data, int argc, closure _, object k, object opq)"
      " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
        CURL *handle = opaque_ptr(opq);
        curl_easy_cleanup(handle);
        return_closcall1(data, k, boolean_t); ")

 ;; TODO: see https://curl.haxx.se/libcurl/c/curl_easy_setopt.html
 ;;       need to encode all the options...
;curl_easy_setopt()
    (define-c curl-easy-setopt
      "(void *data, int argc, closure _, object k, object opq, object option, object param)"
      " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
        CURL *handle = opaque_ptr(opq);
        CURLoption coption = obj_obj2int(option); // TODO: type checking. also could this be truncating data??
        // TODO: param can be many types depending on options
        CURLcode result = curl_easy_setopt(handle, coption, string_str(param)); // TODO: not good enough for str
        return_closcall1(data, k, obj_int2obj(result)); ")

    (define-c curl-easy-perform
      "(void *data, int argc, closure _, object k, object opq)"
      " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
        CURL *handle = opaque_ptr(opq);
        CURLcode result = curl_easy_perform(handle);
        return_closcall1(data, k, obj_int2obj(result)); ")
;curl_easy_getinfo()
; TODO: see https://curl.haxx.se/libcurl/c/curl_easy_getinfo.html
;    (define-c curl-easy-getinfo
;      "(void *data, int argc, closure _, object k, object opq)"
;      " Cyc_check_type(data, Cyc_is_opaque, c_opaque_tag, opq);
;        CURL *handle = opaque_ptr(opq);
;        CURLcode result = curl_easy_perform(handle);
;        return_closcall1(data, k, obj_int2obj(result)); ")

  )
)

