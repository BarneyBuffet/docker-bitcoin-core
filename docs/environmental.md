---
Title:   Docker Bitcoin Core - Environmental Options
Summary: What this repository is all about
Authors: Barney Buffet
Date:    September 12, 2021
---

Below is a list of Docker environmental options that get templated into a config file.

---

Execute command when a relevant alert is received or we see a really long fork (%s in cmd is replaced by message)

```bash
ALERT_NOTIFY=<cmd>
```

---

If this block is in the chain assume that it and its ancestors are valid and potentially skip their script verification (0 to verify all,

default:
0000000000000000000b9d2ec5a352ecba0592946514a92f14319dc2b367fc72,

testnet:
000000000000006433d1efec504c53ca332b64963c425395515b01977bd7b3b0,

signet:
0000002a1de0f46379358c1fd09906f7ac59adf3712323ed90eb59e4c183c020)

```bash
ASSUME_VALID=0000000000000000000b9d2ec5a352ecba0592946514a92f14319dc2b367fc72
```

---

Maintain an index of compact filters by block (default: false, values: basic). If <type> is not supplied or if <type> = true, indexes for all known types are enabled.

```bash
BLOCK_FILTER_INDEX=false
```

---

Execute command when the best block changes (%s in cmd is replaced by block hash)

```bash
BLOCK_NOTIFY=<cmd>
```

---

Extra transactions to keep in memory for compact block reconstructions (default: 100)

```bash
BLOCK_RECONSTRUCTION_EXTRA_TXN=100
```

---

Specify directory to hold blocks subdirectory for *.dat files (default: <datadir>)

```bash
BLOCKS_DIR=/bitcoin
```

---

Whether to reject transactions from network peers. Automatic broadcast and rebroadcast of any transactions from inbound peers is disabled, unless the peer has the 'forcerelay' permission. RPC transactions are not affected. (default: false)

```bash
BLOCKS_ONLY=false
```

---

Specify path to read-only configuration file. Relative paths will be prefixed by datadir location. (default: bitcoin.conf)

```bash
CONF=bitcoin.conf
```

---

Run in the background as a daemon and accept commands

```bash
DAEMON=true
```

---

Specify data directory. This is set by the docker image and should not be changed

```bash
DATA_DIR=/bitcoin
```

---

Maximum database cache size <n> MiB (4 to 16384, default: 450). In addition, unused mempool memory is shared for this cache (see -maxmempool).

```bash
DB_CACHE=450
```

---

Specify location of debug log file. Relative paths will be prefixed by a net-specific datadir location. (-nodebuglogfile to disable; default: debug.log)

```bash
DEBUG_LOG_FILE=debug.log
```

---

Specify additional configuration file, relative to the -datadir path (only useable from configuration file, not command line)

```bash
INCLUDE_CONF=<file>
```

---

Imports blocks from external file on startup

```bash
LOAD_BLOCK=<file>
```

---

Keep the transaction memory pool below <n> megabytes (default: 300)

```bash
MAX_MEM_POOL=300
```

---

Keep at most <n> unconnectable transactions in memory (default: 100)

```bash
MAX_ORPHAN_TX=100
```

---

Do not keep transactions in the mempool longer than <n> hours (default: 336)

```bash
MEM_POOL_EXPIRY=336
```

---

Set the number of script verification threads (-4 to 15, 0 = auto, <0 = leave that many cores free, default: 0)

```bash
PAR=0
```

---

Whether to save the mempool on shutdown and load on restart (default: true)

```bash
PERSIST_MEMPOOL=true
```

---

Specify pid file. Relative paths will be prefixed by a net-specific datadir location. (default: bitcoind.pid)

```bash
PID=bitcoind.pid
```

---

Reduce storage requirements by enabling pruning (deleting) of old blocks. This allows the pruneblockchain RPC to be called to delete specific blocks, and enables automatic pruning of old blocks if a target size in MiB is provided. This mode is incompatible with -txindex and -rescan. Warning: Reverting this setting requires re-downloading the entire blockchain. (default: 0 = disable pruning blocks, 1 = allow manual pruning via RPC, >=550 = automatically prune block files to stay under the specified target size in MiB)

```bash
PRUNE=0
```

---

Rebuild chain state and block index from the blk*.dat files on disk

```bash
REINDEX=true
```

---

Rebuild chain state from the currently indexed blocks. When in pruning mode or if blocks on disk might be corrupted, use full -reindex instead.

```bash
REINDEX_CHAINSTATE=true
```

---

Specify path to dynamic settings data file. Can be disabled with -nosettings. File is written at runtime and not meant to be edited by users (use bitcoin.conf instead for custom settings). Relative paths will be prefixed by datadir location. (default: settings.json)

```bash
SETTINGS=settings.json
```

---

Execute command on startup.

```bash
STARTUP_NOTIFY=<cmd>
```

---

Create new files with system default permissions, iP

```bash
SYS_PERMS=1
```

---

Maintain a full transaction index, used by the getrawtransaction rpc call (default: false)

```bash
TX_INDEX=false
```

---

## Connection options

Add a node to connect to and attempt to keep the connection open (see the `addnode` RPC command help for more info). This option can be specified multiple times to add multiple nodes.

```bash
ADD_NODE=<address:port>
```

---

Specify asn mapping used for bucketing of the peers (default: ip_asn.map). Relative paths will be prefixed by the net-specific datadir location.

```bash
ASMAP=ip_asn.map
```

---

Default duration (in seconds) of manually configured bans (default: 86400)

```bash
BAN_TIME=86400
```

---

Bind to given address and always listen on it (default: 0.0.0.0). Use [host]:port notation for IPv6. Append =onion to tag any incoming connections to that address and port as incoming Tor connections (default: 127.0.0.1:8334=onion, testnet: 127.0.0.1:18334=onion, signet: 127.0.0.1:38334=onion, regtest: 127.0.0.1:18445=onion)

```bash
BIND=0.0.0.0
```

---

Connect only to the specified node; -noconnect disables automatic connections (the rules for this peer are the same as for -addnode). This option can be specified multiple times to connect to multiple nodes.

```bash
CONNECT=<ip>
```

---

Discover own IP addresses (default: true when listening and no -externalip or -proxy)

```bash
DISCOVER=true
```

---

Allow DNS lookups for -addnode, -seednode and -connect (default: true)

```bash
DNS=true
```

---

Query for peer addresses via DNS lookup, if low on addresses (default: true unless -connect used)

```bash
dnDNS_SEEDsseed=true
```

---

Specify your own public address

```bash
EXTERNAL_IP=<ip>
```

---

Always query for peer addresses via DNS lookup (default: false)

```bash
FORCE_DNS_SEED=false
```

---

Accept connections from outside (default: false if no -proxy or -connect)

```bash
LISTEN=false
```

---

Automatically create Tor onion service (default: false)

```bash
LISTEN_ONION=false
```

---

Maintain at most <n> connections to peers (default: 125)

```bash
MAX_CONNECTIONS=125
```

---

Maximum per-connection receive buffer, <n>*1000 bytes (default: 5000)

```bash
MAX_RECEIVE_BUFFER=5000
```

---

Maximum per-connection send buffer, <n>*1000 bytes (default: 1000)

```bash
MAX_SEND_BUFFER=1000
```

---

Maximum allowed median peer time offset adjustment. Local perspective of time may be influenced by peers forward or backward by this amount. (default: 4200 seconds)

```bash
MAX_TIME_ADJUSTMENT=4200
```

---

Tries to keep outbound traffic under the given target (in MiB per 24h). Limit does not apply to peers with 'download' permission. 0 = no limit (default: 0)

```bash
MAX_UPLOAD_TARGET=0
```

---

Enable all P2P network activity (default: true). Can be changed by the setnetworkactive RPC command

```bash
NETWORK_ACTIVE=true
```

---

Use separate SOCKS5 proxy to reach peers via Tor onion services, set -noonion to disable (default: -proxy)

```bash
ONION=<ip:port>
```

---

Make outgoing connections only through network <net> (ipv4, ipv6 or onion). Incoming connections are not affected by this option. This option can be specified multiple times to allow multiple networks.

```bash
ONLY_NET=<net>
```

---

Serve compact block filters to peers per BIP 157 (default: false)

```bash
PEER_BLOCK_FILTERS=false
```

---

Support filtering of blocks and transaction with bloom filters (default: false)

```bash
PEER_BLOOM_FILTERS=false
```

---

Relay non-P2SH multisig (default: true)

```bash
PERMIT_BARE_MULTISIG=true
```

---

Listen for connections on <port>. Nodes not using the default ports (default: 8333, testnet: 18333, signet: 38333, regtest: 18444) are unlikely to get incoming connections.

```bash
PORT=8333
```

---

Connect through SOCKS5 proxy, set -noproxy to disable (default: disabled)

```bash
PROXY=<ip:port>
```

---

Randomize credentials for every proxy connection. This enables Tor stream isolation (default: true)

```bash
PROXY_RANDOMIZE=true
```

---

Connect to a node to retrieve peer addresses, and disconnect. This option can be specified multiple times to connect to multiple nodes.

```bash
SEED_NODE=<ip>
```

---

Specify connection timeout in milliseconds (minimum: 1, default: 5000)

```bash
TIMEOUT=5000
```

---

Tor control port to use if onion listening enabled (default: 127.0.0.1:9051)

```bash
TOR_CONTROL=127.0.0.1:9051
```

---

Tor control port password (default: empty)

```bash
TOR_PASSWORD=password
```

---

Use UPnP to map the listening port (default: false)

```bash
UPNP=false
```

---

Bind to the given address and add permission flags to the peers connecting to it. Use [host]:port notation for IPv6. Allowed permissions: bloomfilter (allow requesting BIP37 filtered blocks and transactions), noban (do not ban for misbehavior; implies download), forcerelay (relay transactions that are already in the mempool; implies relay), relay (relay even in -blocksonly mode, and unlimited transaction announcements), mempool (allow requesting BIP35 mempool contents), download (allow getheaders during IBD, no disconnect after maxuploadtarget limit), addr (responses to GETADDR avoid hitting the cache and contain random records with the most up-to-date info). Specify multiple permissions separated by commas (default: download,noban,mempool,relay). Can be specified multiple times.

```bash
WHITE_BIND=<[permissions@]addr>
```

---

Add permission flags to the peers connecting from the given IP address (e.g. 1.2.3.4) or CIDR-notated network (e.g. 1.2.3.0/24). Uses the same permissions as -whitebind. Can be specified multiple times.

```bash
WHITE_LIST=<[permissions@]IP address or network>
```

---

## Debugging/Testing options:

Output debugging information (default: -nodebug, supplying <category> is optional). If <category> is not supplied or if <category> = 1, output all debugging information. <category> can be: net, tor, mempool, http, bench, zmq, walletdb, rpc, estimatefee, addrman, selectcoins, reindex, cmpctblock, rand, prune, proxy, mempoolrej, libevent, coindb, qt, leveldb, validation.

```bash
DEBUG=<category>
```

---

Exclude debugging information for a category. Can be used in conjunction with -debug=1 to output debug logs for all categories except one or more specified categories.

```bash
DEBUG_EXCLUDE=<category>
```

---

Print help message with debugging options and exit

```bash
HELP_DEBUG=true
```

---

Include IP addresses in debug output (default: false)

```bash
LOG_IPS=false
```

---

Prepend debug output with name of the originating thread (only available on platforms supporting thread_local) (default: false)

```bash
LOG_THREAD_NAMES=false
```

---

Prepend debug output with timestamp (default: true)

```bash
LOG_TIMESTAMPS=true
```

---

Send trace/debug info to console (default: true when no -daemon. To disable logging to file, set -nodebuglogfile)

```bash
PRINT_TO_CONSOLE=true
```

---

Shrink debug.log file on client startup (default: true when no -debug)

```bash
SHRINK_DEBUG_FILE=true
```

---

Append comment to the user agent string

```bash
UA_COMMENT=<cmt>
```

---

## Chain selection options

Use the chain <chain> (default: main). Allowed values: main, test, signet, regtest

```bash
CHAIN=main
```

---

Use the signet chain. Equivalent to -chain=signet. Note that the network is defined by the -signetchallenge parameter

```bash
SIGNET=true
```

---

Blocks must satisfy the given script to be considered valid (only for signet networks; defaults to the global default signet test network challenge)

```bash
SIGNET_CHALLENGE
```

---

Specify a seed node for the signet network, in the hostname[:port] format, e.g. sig.net:1234 (may be used multiple times to specify multiple seed nodes; defaults to the global default signet test network seed node(s))

```bash
SIGNET_SEED_NODE=<host[:port]>
```

---

Use the test chain. Equivalent to -chain=test.

```bash
TEST_NET=true
```

---

## Node relay options

Equivalent bytes per sigop in transactions for relay and mining (default: 20)

```bash
BYTE_PER_SIGOP=20
```

---

Relay and mine data carrier transactions (default: true)

```bash
DATA_CARRIER=true
```

---

Maximum size of data in data carrier transactions we relay and mine (default: 83)

```bash
DATA_CARRIER_SIZE=83
```

---

Fees (in BTC/kB) smaller than this are considered zero fee for relaying, mining and transaction creation (default: 0.00001)

```bash
MIN_RELAY_TX_FEE=0.00001
```

---

Add 'forcerelay' permission to whitelisted inbound peers with default permissions. This will relay transactions even if the transactions were already in the mempool. (default: false)

```bash
WHITE_LIST_FORCE_RELAY=false
```

---

Add 'relay' permission to whitelisted inbound peers with default permissions. This will accept relayed transactions even when not relaying transactions (default: true)

```bash
WHITE_LIST_RELAY=true
```

---

## Block creation options

Set maximum BIP141 block weight (default: 3996000)

```bash
BLOCK_MAX_WEIGHT=3996000
```

---

Set lowest fee rate (in BTC/kB) for transactions to be included in block creation. (default: 0.00001)

```bash
BLOCK_MIN_TX_FEE=0.00001
```

---

## RPC server options

Accept public REST requests (default: false)

```bash
REST=false
```

---

Allow JSON-RPC connections from specified source. Valid for <ip> are a single IP (e.g. 1.2.3.4), a network/netmask (e.g. 1.2.3.4/255.255.255.0) or a network/CIDR (e.g. 1.2.3.4/24). This option can be specified multiple times.

```bash
RPC_ALLOW_IP=127.0.0.1
```

---

Username and HMAC-SHA-256 hashed password for JSON-RPC connections. The field <userpw> comes in the format: <USERNAME>:<SALT>$<HASH>. A canonical python script is included in /usr/local/share/rpcauth.py. The client then connects normally using the rpcuser=<USERNAME>/rpcpassword=<PASSWORD> pair of arguments. This option can be specified multiple times

```bash
RPC_USER=<username>
RPC_PASSWORD=<password>
# rpcauth=<USERNAME>:<SALT>$<HASH>
```

---

Bind to given address to listen for JSON-RPC connections. Do not expose the RPC server to untrusted networks such as the public internet! This option is ignored unless -rpcallowip is also passed. Port is optional and overrides -rpcport. Use [host]:port notation for IPv6. This option can be specified multiple times (default: 127.0.0.1 and ::1 i.e., localhost)

```bash
RPC_BIND=127.0.0.1:8332
```

---

Location of the auth cookie. Relative paths will be prefixed by a net-specific datadir location. (default: data dir)

```bash
RPC_COOKIE_FILE=<loc>
```

---

Listen for JSON-RPC connections on <port> (default: 8332, testnet: 18332, signet: 38332, regtest: 18443)

```bash
RPC_PORT=8332
```

---

Sets the serialization of raw transaction or block hex returned in non-verbose mode, non-segwit(false) or segwit(true) (default: true)

```bash
RPC_SERIAL_VERSION=true
```

---

Set the number of threads to service RPC calls (default: 4)

```bash
RPC_THREADS=4
```

---

Set a whitelist to filter incoming RPC calls for a specific user. The field <whitelist> comes in the format: <USERNAME>:<rpc 1>,<rpc 2>,...,<rpc n>. If multiple whitelists are set for a given user, they are set-intersected. See -rpcwhitelistdefault documentation for information on default whitelist behavior.

```bash
RPC_WHITELIST=<whitelist>
```

---

Sets default behavior for rpc whitelisting. Unless `RPC_WHITE_LIST_DEFAULT` is set to false, if any `RPC_WHITELIST` is set, the rpc server acts as if all rpc users are subject to empty-unless-otherwise-specified whitelists. If `RPC_WHITE_LIST_DEFAULT` is set to true and no `RPC_WHITELIST` is set, rpc server acts as if all rpc users are subject to empty whitelists.

```bash
RPC_WHITE_LIST_DEFAULT=true
```

---

Accept command line and JSON-RPC commands

```bash
SERVER=true
```

---

## ZeroMQ

[https://github.com/bitcoin/bitcoin/blob/master/doc/zmq.md](https://github.com/bitcoin/bitcoin/blob/master/doc/zmq.md)
[ZeroMQ](https://zeromq.org/) is a lightweight wrapper around TCP connections, inter-process communication, and shared-memory, providing various message-oriented semantics such as publish/subscribe, request/reply, and push/pull.

```bash
ZMQ_PUB_HASH_TX=<tcp://ip:28332>
ZMQ_PUB_HASH_BLOCK=<tcp://ip:28332>
ZMQ_PUB_RAW_BLOCK=<tcp://ip:28332>
ZMQ_PUB_RAW_TX=<ipc://location.of.socket>
ZMQ_PUB_SEQUENCE=<10000>
```
