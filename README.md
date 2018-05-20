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
* normal token Transfer()
* token Transfer() with cliff,vest
* acceptDeposit()
* acceptOffChainDeposit()

Following phases are defined:
1. **__PHASE PAUSE__**: All affected functions are disabled. 
2. **__PHASE SALE#1__**: All affected functions are disabled, except acceptOffChainDeposit()
3. **__PHASE SALE#2__**: All affected functions are disabled, except acceptDeposit() and acceptOffChainDeposit()
4. **__PHASE SALE#3__**: same as SALE#2 phase but different paramteres
5. **__PHASE PRE FINISH__**: All affected functions are enabled
6. **__PHASE FINISH__**: All affected functions are disabled, except token transfers functions

### [1] ILK token contracts

Contains the basic token logic, include standard ERC20 functions (transfer, approve, etc.) and some ILK token specific functions as well (eg. timelocked transaction with vesting service). 

### [2] ICO contract

ICO related smart contract, only relevant in ICO phase.

### [3] Token multisig contract

Also connected to ICO, this token only multisig wallets will store specific tokens for community events and for ILK platform.
