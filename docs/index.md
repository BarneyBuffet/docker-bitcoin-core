---
Title:   Docker Bitcoin Core
Summary: What this repository is all about
Authors: Barney Buffet
Date:    September 12, 2021
---

A docker image for running bitcoin-core daemon

Bitcoin Core is a reference client that implements the Bitcoin protocol for remote procedure call (RPC) use. It is also the second Bitcoin client in the network's history. Learn more about Bitcoin Core on the Bitcoin Developer Reference docs.

Image Documentation: [https://BarneyBuffet.github.io/docker-bitcoin-core](https://BarneyBuffet.github.io/docker-bitcoin-core)
Image Code: [https://github.com/BarneyBuffet/docker-bitcoin-core](https://github.com/BarneyBuffet/docker-bitcoin-core)

## What does this image do?

This runs a Ubuntu server for the bitcoin-core daemon. The image does not include a wallet or the gui.

The [dockerfile](https://github.com/BarneyBuffet/docker-bitcoin-core/blob/main/Dockerfile) for this image does the following:

1. Install package dependencies
2. Downloads the source code for the referenced version
3. Check the source code download against the signed pgp keys
4. Extracts the source code, configures and compiles the code
5. Set's up nonroot user for running the daemon
6. If bitcoin.conf file does not exists it will copy one across and template it out based on env sets
7. Start up bitcoind

## Using this image

To run a detached docker container with no env settings enter the below command.

```bash
docker run -d  --it \
  --name bitcoin-core \
  -v /local/path/to/tor:/tor \
  -v /local/path/to/bitcoin-core:/bitcoin \
  barneybuffet/bitcoin-core:latest:dev
```

For more complicate docker-compose files have a look in [docker-compose folder](https://github.com/BarneyBuffet/docker-bitcoin-core/blob/main/docker-compose/).

## Bitcoin core configuration

Bitcoin core configuration is set in `bitcoin.conf`. This docker image keeps this configuration file at `/bitcoin/bitcoin.conf`. The folder can be mounted and file changes are persisted. Otherwise you can set you configuration options using docker environmental variables.

A full list of configuration options is in the [documentation folder]()


## Checking it is working

To check the server is running open a terminal window within your running container and run the following command

```bash
bitcoin-cli getblockchaininfo
```

When “bitcoind” is still starting, you may get an error message like “verifying blocks”. That’s normal, just give it a few minutes.

Among other infos, the “verificationprogress” is shown. Once this value reaches almost 1 (0.999…), the blockchain is up-to-date and fully validated.

To confirm you are connected to the network, check active connections with the below command

```bash
bitcoin-cli getconnectioncount 
```

With it, you can check your node on [https://bitnodes.earn.com](https://bitnodes.earn.com)

#### References

* [BitcoinCore](https://bitcoin.org/en/bitcoin-core/)
* [Bitcoin Core Source Code](https://github.com/bitcoin/bitcoin)
* [bitcoin Core Unix Build Notes](https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md)
* [ruimarinho/docker-bitcoin-core](https://github.com/ruimarinho/docker-bitcoin-core)
* [Bitcoin Stackexchange](https://bitcoin.stackexchange.com/)
* [Bitcoin Wiki](https://en.bitcoin.it/wiki/Main_Page)
* [Running Bitcoind Wiki](https://en.bitcoinwiki.org/wiki/Running_Bitcoind)
* [Mastering Bitcoin](https://github.com/bitcoinbook/bitcoinbook)