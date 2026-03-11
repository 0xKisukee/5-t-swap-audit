**THIS CHECKLIST IS NOT COMPLETE**. Use `--show-ignored-findings` to show all the results.
Summary
 - [uninitialized-state](#uninitialized-state) (2 results) (High)
 - [incorrect-equality](#incorrect-equality) (1 results) (Medium)
 - [missing-zero-check](#missing-zero-check) (1 results) (Low)
 - [reentrancy-events](#reentrancy-events) (1 results) (Low)
 - [pragma](#pragma) (1 results) (Informational)
 - [unindexed-event-address](#unindexed-event-address) (1 results) (Informational)
## uninitialized-state
Impact: High
Confidence: High
 - [ ] ID-0
[PoolFactory.s_pools](src/PoolFactory.sol#L28-L29) is never initialized. It is used in:
	- [PoolFactory.createPool(address)](src/PoolFactory.sol#L48-L60)
	- [PoolFactory.getPool(address)](src/PoolFactory.sol#L66-L67)

src/PoolFactory.sol#L28-L29


 - [ ] ID-1
[PoolFactory.s_tokens](src/PoolFactory.sol#L29-L30) is never initialized. It is used in:
	- [PoolFactory.getToken(address)](src/PoolFactory.sol#L67-L71)

src/PoolFactory.sol#L29-L30


## incorrect-equality
Impact: Medium
Confidence: High
 - [ ] ID-2
[TSwapPool.revertIfZero(uint256)](src/TSwapPool.sol#L75-L81) uses a dangerous strict equality:
	- [amount == 0](src/TSwapPool.sol#L76-L77)

src/TSwapPool.sol#L75-L81


## missing-zero-check
Impact: Low
Confidence: Medium
 - [ ] ID-3
[PoolFactory.constructor(address).wethToken](src/PoolFactory.sol#L41) lacks a zero-check on :
		- [i_wethToken = wethToken](src/PoolFactory.sol#L42)

src/PoolFactory.sol#L41


## reentrancy-events
Impact: Low
Confidence: Medium
 - [ ] ID-4
Reentrancy in [TSwapPool._swap(IERC20,uint256,IERC20,uint256)](src/TSwapPool.sol#L411-L437):
	External calls:
	- [outputToken.safeTransfer(msg.sender,1_000_000_000_000_000_000)](src/TSwapPool.sol#L422-L425)
	Event emitted after the call(s):
	- [Swap(msg.sender,inputToken,inputAmount,outputToken,outputAmount)](src/TSwapPool.sol#L425-L430)

src/TSwapPool.sol#L411-L437


## pragma
Impact: Informational
Confidence: High
 - [ ] ID-5
3 different versions of Solidity are used:
	- Version constraint >=0.6.2 is used by:
		-[>=0.6.2](lib/forge-std/src/interfaces/IERC20.sol#L1-L2)
	- Version constraint ^0.8.20 is used by:
		-[^0.8.20](lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol#L2-L3)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#L2-L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#L2-L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#L2-L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#L2-L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#L2-L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Address.sol#L2-L4)
		-[^0.8.20](lib/openzeppelin-contracts/contracts/utils/Context.sol#L2-L4)
	- Version constraint 0.8.20 is used by:
		-[0.8.20](src/PoolFactory.sol#L14-L15)
		-[0.8.20](src/TSwapPool.sol#L14-L15)

lib/forge-std/src/interfaces/IERC20.sol#L1-L2


## unindexed-event-address
Impact: Informational
Confidence: High
 - [ ] ID-6
Event [PoolFactory.PoolCreated(address,address)](src/PoolFactory.sol#L36-L37) has address parameters but no indexed parameters

src/PoolFactory.sol#L36-L37


