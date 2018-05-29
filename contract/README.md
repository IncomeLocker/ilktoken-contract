# InLock contracts
Solidity contracts for InLock (ILK) token. Details on https://inlock.io/

## `Token` contract
Token contract uses the standard ERC20 functions ( https://en.wikipedia.org/wiki/ERC20 ) with some special functions.

### Token transfer special criterias
For transfering tokens it should have at least one of the following criterias:
 - The ICO has `preFinish` status
 - The ICO has `finish` status
 - Listed on `transferRight` list in the ICO contract

### Constructor arguments
 - `address _owner`<br>
 - `address _libAddress`<br>
 - `address _dbAddress`<br>
 - `address _icoAddress`

### Variables
 - `uint256 totalSupply`<br>
 - `address libAddress`<br>
 - `address db`<br>
 - `address ico`<br>

### Public functions
 - `bulkTransfer(address[] _to, uint256[] _amount)`

### Restricted functions
 - `changeLibAddress(address _libAddress)`<br>
 - `changeDBAddress(address _dbAddress)`<br>
 - `changeIcoAddress(address _icoAddress)`<br>

## `Ico` contract
### Constructor arguments
 - `address _owner`<br>
 - `address _libAddress`<br>
 - `address _tokenAddress`<br>
 - `address _offchainUploaderAddress`

### Structures
 - `vesting_s`
    - `uint256 amount`
    - `uint256 startBlock`
    - `uint256 endBlock`
    - `uint256 claimedAmount`

### Variables
 - `mapping(address => bool) KYC`<br>
 - `mapping(address => bool) transferRight`<br>
 - `mapping(address => vesting_s) vesting`<br>
 - `uint256 currentPhase`
    - 0 = `pause`
    - 1 = `privateSale1`
    - 2 = `privateSale2`
    - 3 = `sales`
    - 4 = `preFinish`
    - 5 = `finish`
 - `uint256 currentRate`<br>
 - `uint256 currentRateM`<br>
 - `uint256 privateSale1Hardcap`<br>
 - `uint256 privateSale2Hardcap`<br>
 - `uint256 thisBalance`<br>
 - `address offchainUploaderAddress`<br>
 - `address libAddress`<br>
 - `address token`

### Public functions
 - `buy(address _beneficiary)`<br>
 - `claimVesting()`

### Restricted functions
 - `setVesting(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock)`<br>
 - `setKYC(address[] _on, address[] _off)`<br>
 - `setTransferRight(address[] _allow, address[] _disallow)`<br>
 - `setCurrentRate(uint256 _currentRate)`<br>
 - `setOffchainUploaderAddress(address _offchainUploaderAddress)`<br>
 - `setCurrentPhase(phaseType _phase)`<br>
 - `offchainUpload(address[] _beneficiaries, uint256[] _rewards)`

### Constant functions
 - `allowTransfer(address _owner)`<br>
 - `calculateReward(uint256 _input)`<br>
 - `calcVesting(address _owner)`

### Events
 - `Brought(address _owner, address _beneficiary, uint256 _input, uint256 _output)`<br>
 - `VestingDefined(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock)`<br>
 - `VestingClaimed(address _beneficiary, uint256 _amount)`

## `MultiOwnerWallet` contract
### Constructor arguments
 - `address _tokenAddress`<br>
 - `uint256 _actionVotedRate`<br>
 - `address[] _owners`

### Structures
 - `action_s`
    - `address origin`
    - `uint256 voteCounter`
    - `mapping(address => bool) voters`

### Variables
 - `mapping(address => bool) owners`<br>
 - `mapping(bytes32 => action_s) actions`<br>
 - `uint256 actionVotedRate`<br>
 - `uint256 ownerCounter`<br>
 - `address token`

### Restricted functions
 - `transfer(address _to, uint256 _amount)`<br>
 - `revokeTransferAction(address _to, uint256 _amount)`<br>
 - `bulkTransfer(address[] _to, uint256[] _amount)`<br>
 - `revokeBulkTransferAction(address[] _to, uint256[] _amount)`<br>
 - `changeTokenAddress(address _tokenAddress)`<br>
 - `revokeChangeTokenAction(address _tokenAddress)`<br>
 - `addNewOwner(address _owner)`<br>
 - `revokeAddNewOwnerAction(address _owner)`<br>
 - `delOwner(address _owner)`<br>
 - `revokeDelOwnerAction(address _owner)`<br>
 - `revokeActionByHash(bytes32 _hash)`

### Constant functions
 - `selfBalance()`<br>
 - `balanceOf(address _owner)`<br>
 - `hasVoted(bytes32 _hash, address _owner)`

### Events
 - `newTransferAction(bytes32 _hash, address _to, uint256 _amount, address _origin)`<br>
 - `newBulkTransferAction(bytes32 _hash, address[] _to, uint256[] _amount, address _origin)`<br>
 - `newChangeTokenAddressAction(bytes32 _hash, address _tokenAddress, address _origin)`<br>
 - `newAddNewOwnerAction(bytes32 _hash, address _owner, address _origin)`<br>
 - `newDelOwnerAction(bytes32 _hash, address _owner, address _origin)`<br>
 - `vote(bytes32 _hash, address _voter)`<br>
 - `revokedAction(bytes32 _hash)`<br>
 - `votedAction(bytes32 _hash)`
