# docker-bitcoin-core
A docker image for running bitcoin-core daemon

Bitcoin Core is a reference client that implements the Bitcoin protocol for remote procedure call (RPC) use. It is also the second Bitcoin client in the network's history. Learn more about Bitcoin Core on the Bitcoin Developer Reference docs.


## Check Blockchain

```bash
bitcoin-cli -conf=/bitcoin/bitcoin.conf getblockchaininfo
```

When “bitcoind” is still starting, you may get an error message like “verifying blocks”. That’s normal, just give it a few minutes.

Among other infos, the “verificationprogress” is shown. Once this value reaches almost 1 (0.999…), the blockchain is up-to-date and fully validated.


Inspect image

```bash
docker run -it --entrypoint bash bitcoind:dev
```

```bash
bitcoin-cli getconnectioncount 
```


Verifying everything is working
Find your public IP
curl https://ipinfo.io/ip
With it, you can check your node on https://bitnodes.earn.com

[Mastering Bitcoin](https://github.com/bitcoinbook/bitcoinbook)

#### References

* [](https://bitcoin.org/en/bitcoin-core/)
* [](https://github.com/bitcoin/bitcoin)
* [](https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md)
* [](https://leftasexercise.com/2018/04/12/building-a-bitcoin-container-with-docker/)
* [](https://github.com/ruimarinho/docker-bitcoin-core)
* [](https://jonatack.github.io/articles/how-to-compile-bitcoin-core-and-run-the-tests)
* [](https://github.com/kdmukai/raspi4_bitcoin_node_tutorial)
* [](https://bitcoin.stackexchange.com/)
* [](https://en.bitcoin.it/wiki/Setting_up_a_Tor_hidden_service)
* [](https://bitcoin.stackexchange.com/questions/70069/how-can-i-setup-bitcoin-to-be-anonymous-with-tor)
* [Running Bitcoin & Lightning Nodes Over The Tor Network (2021 Edition)](https://stopanddecrypt.medium.com/running-bitcoin-lightning-nodes-over-the-tor-network-2021-edition-489180297d5)
* [Running Bitcoind](https://en.bitcoinwiki.org/wiki/Running_Bitcoind)