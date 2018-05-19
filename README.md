# ilktoken-contract
Solidity contract for inlock (ILK) token. Details on https://inlock.io/

Standard ERC20 token implementation with the following structure: <br>
 [1] Token [Proxy] --> Token [Library] --> Token [database]<br>
 [2] ICO contract<br>
 [3] Token multisig contract<br>
 
Details of components
# [1] ILK token contracts

Contains the basic token logic, include standard ERC20 functions (transfer, approve, etc.) and some ILK token specific functions as well (eg. timelocked transaction with vesting service). 

# [2] ICO contract

ICO related smart contract, only relevant in ICO phase.

# [3] Token multisig contract

Also connected to ICO, this token only multisig wallets will store specific tokens for community events and for ILK platform.
