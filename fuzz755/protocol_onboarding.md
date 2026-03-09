# Protocol Onboarding

## Basic Info

- Protocol Name: TSwap
- Website: tswap.xyz
- Documentation: [README.md](../README.md)
- Key Points of Contact: Patrick Collins

## Requirements

- Git
- Foundry

```bash
git clone https://github.com/Cyfrin/5-t-swap-audit
cd 5-t-swap-audit
make
```

## Protocol Code

- Link to Repo: https://github.com/Cyfrin/5-t-swap-audit
- Commit hash: 7bd52c6a75f1115b23e0cff0fa16f7c522703fcd
- Contracts in Scope:
```
./src/
PoolFactory.sol
TSwapPool.sol
```
- Solc Version: 0.8.20

## Protocol Details

- Is it a fork of an existing protocol? Which one?
It's not a fork but it is greatly inspired from Uniswap V1

- Does the project use rollups?
No

- Does the protocol use zero-knowledge proofs?
No

- Will the protocol be multi-chain? Specify them.
No

- Does the protocol use external protocols? (oracles, AMMS, etc...)
No

- Which tokens do you expect to interact with? (ERC20, ERC721, etc...)
ERC20

- Are there any off-chain processes? (keeper bots, etc...)
No

- Are there any upgradeable contracts in the protocol?
No

## Roles

- Liquidity Providers: Users who have liquidity deposited into the pools. Their shares are represented by the LP ERC20 tokens. They gain a 0.3% fee every time a swap is made. 
- Users: Users who want to swap tokens.

## Risks

None

## Known Issues

None

## Previous Audits and Reports

None

## Resources

- Documentation: [README.md](../README.md)

## [[The Rekt Test]]

Not applicable.