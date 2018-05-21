# ilktoken-contract
Solidity contract for inlock (ILK) token. Details on https://inlock.io/

Following information based on Income Locker (inlock.io) whitepaper: https://inlock.io/wp-content/uploads/2018/04/Whitepaper_V1.04.pdf
 - Latest version: V1.04 release date: 2018.04.21

Standard ERC20 token implementation with the following structure: <br>
 [1] Token [Proxy] --> Token [Library] --> Token [database]<br>
 [2] ICO contract<br>
 [3] Token multisig contract<br>
 
## Details of components
### General informations
Token contracts (proxy, lib, db) and ICO contact are linked together within some special phases. Phases affects to the following functions:
* normal token `Transfer()`
* token `TransferWithVest()` with cliff,vest
* `acceptDeposit()`
> Only whitelisted addresses can deposit in specific phases.
* `acceptOffChainDeposit()`
> Only predefined addresses can call this function in specific phases. owner can manage predefined addresses with `setOffChainDepositOwner()`

#### Token Sale Phases
Owner can change between phases with `setTokenSalePhase()` function 
Following phases are defined:
1. **__PHASE PAUSE__**: All affected functions are disabled. 
2. **__PHASE SALE#1__**: All affected functions are disabled, except `acceptOffChainDeposit()`

| Contribution  | Bonus multipl | | 
| ------------- |--------------:|-|
| >25.000 ILK   | 42% | |
| >10.000 ILK   | 37% | |
| >=2.000 ILK   | 33% | |
| <2.000 ILK    | throw | |

3. **__PHASE SALE#2__**: All affected functions are disabled, except `acceptDeposit()` and `acceptOffChainDeposit()`

| Contribution  | Bonus multipl | | 
| ------------- |--------------:|-|
| >125.000 ILK   | 29% | |
| >100.000 ILK   | 24% | |
| >=10.000 ILK   | 21% | |
| <10.000 ILK    | throw | |

4. **__PHASE SALE#3__**: same as SALE#2 phase but different paramteres

| Contribution  | Bonus multipl | | 
| ------------- |--------------:|-|
| >10.000 ILK   | 17% | |
| >2.000 ILK   | 12% | |
| >=1.000 ILK   | 9% | |
| <1.000 ILK    | throw | |

5. **__PHASE PRE FINISH__**: All affected functions are enabled

| Contribution  | Bonus multipl | | 
| ------------- |--------------:|-|
| >=1.000 ILK   | 0% | |
| <1.000 ILK    | throw | |

6. **__PHASE FINISH__**: All affected functions are disabled, except token transfers functions

### [1] ILK token contracts

Contains the basic token logic, include standard ERC20 functions (transfer, approve, etc.) and some ILK token specific functions as well (eg. timelocked transaction with vesting service). 

### [2] ICO contract

ICO related smart contract, only relevant in ICO phase.

### [3] Token multisig contract

Also connected to ICO, this token only multisig wallets will store specific tokens for community events and for ILK platform.
