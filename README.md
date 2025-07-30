# Sample Polkadot Hardhat Project

This project demonstrates how to use Hardhat with Polkadot. It comes with a sample contract, a test for that contract, and a Hardhat Ignition module that deploys that contract.

1) To setup the project, run the following command:

```shell
mkdir hardhat-project
cd hardhat-project
docker run -it --rm -v $(pwd):/project polkadot-hardhat-quickstart:test
```

2) If you close the shell accidentally, you can re-enter the container using the same command:

```shell
docker run -it --rm -v $(pwd):/project polkadot-hardhat-quickstart:test
```

3) Try running some of the following tasks:

```shell
npx hardhat test
npx hardhat node
npx hardhat compile
```
