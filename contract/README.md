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
- `address _owner`
- `address _libAddress`
- `address _dbAddress`
- `address _icoAddress`

### Variables
- `uint256 totalSupply`
- `address libAddress`
- `address db`
- `address ico`
- `address owner`

### Public functions
- `bulkTransfer(address[] _to, uint256[] _amount)`

### Restricted functions
- `changeLibAddress(address _libAddress)`
- `changeDBAddress(address _dbAddress)`
- `changeIcoAddress(address _icoAddress)`
- `replaceOwner(address _owner)`

## `TokenDB` contract
### Constructor arguments
- `address _owner`
- `address _tokenAddress`
- `address _icoAddress`
- `address _oldDBAddress`

### Structures
- `action_s`
  - `uint256 amount`
  - `bool valid`

### Variables
- `mapping(address => mapping(address => uint256)) public allowance`
- `mapping(address => balances_s) public balances`
- `address public tokenAddress`
- `address public oldDBAddress`

### Restricted functions
- `changeTokenAddress(address _tokenAddress)`
- `transfer(address _from, address _to, uint256 _amount)`
- `bulkTransfer(address _from, address[] _to, uint256[] _amount)`
- `setAllowance(address _owner, address _spender, uint256 _amount)`

### Constant functions
- `getAllowance(address _owner, address _spender)`
- `balanceOf(address _owner) public view returns(bool _success, uint256 _balance)`

## `Ico` contract
### Constructor arguments
- `address _owner`
- `address _libAddress`
- `address _tokenAddress`
- `address _offchainUploaderAddress`
- `address _setKYCAddress`
- `address _setRateAddress`

### Structures
- `vesting_s`
  - `uint256 amount`
  - `uint256 startBlock`
  - `uint256 endBlock`
  - `uint256 claimedAmount`

### Variables
- `mapping(address => bool) KYC`
- `mapping(address => bool) transferRight`
- `mapping(address => vesting_s) vesting`
- `uint256 currentPhase`
  - 0 = `pause`
  - 1 = `privateSale1`
  - 2 = `privateSale2`
  - 3 = `sales1`
  - 4 = `sales2`
  - 5 = `sales3`
  - 6 = `sales4`
  - 7 = `preFinish`
  - 8 = `finish`
- `uint256 currentRate`
- `uint256 currentRateM`
- `uint256 privateSale1Hardcap`
- `uint256 privateSale2Hardcap`
- `uint256 thisBalance`
- `address offchainUploaderAddress`
- `address setKYCAddress`
- `address setRateAddress`
- `address libAddress`
- `address token`

### Public functions
- `buy(address _beneficiary)`
- `claimVesting()`

### Restricted functions
- `changeLibAddress(address _libAddress)`
- `changeOffchainUploaderAddress(address _offchainUploaderAddress)`
- `changeKYCAddress(address _setKYCAddress)`
- `changeSetRateAddress(address _setRateAddress)`
- `setVesting(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock)`
- `setKYC(address[] _on, address[] _off)`
- `setTransferRight(address[] _allow, address[] _disallow)`
- `setCurrentRate(uint256 _currentRate)`
- `setCurrentPhase(phaseType _phase)`
- `offchainUpload(address[] _beneficiaries, uint256[] _rewards)`
- `replaceOwner(address _owner)`

### Constant functions
- `allowTransfer(address _owner)`
- `calculateReward(uint256 _input)`
- `calcVesting(address _owner)`

### Events
- `Brought(address _owner, address _beneficiary, uint256 _input, uint256 _output)`
- `VestingDefined(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock)`
- `VestingClaimed(address _beneficiary, uint256 _amount)`

## `MultiOwnerWallet` contract
### Constructor arguments
- `address _tokenAddress`
- `uint256 _actionVotedRate`
- `address[] _owners`

### Structures
- `action_s`
  - `address origin`
  - `uint256 voteCounter`
  - `uint256 uid`
  - `mapping(address => bool) voters`

### Variables
- `mapping(address => bool) owners`
- `mapping(bytes32 => action_s) actions`
- `uint256 actionVotedRate`
- `uint256 ownerCounter`
- `uint256 voteUID`
- `address token`

### Restricted functions
- `transfer(address _to, uint256 _amount)`
- `bulkTransfer(address[] _to, uint256[] _amount)`
- `changeTokenAddress(address _tokenAddress)`
- `addNewOwner(address _owner)`
- `delOwner(address _owner)`

### Constant functions
- `selfBalance()`
- `balanceOf(address _owner)`
- `hasVoted(bytes32 _hash, address _owner)`

### Events
- `newTransferAction(bytes32 _hash, address _to, uint256 _amount, address _origin)`
- `newBulkTransferAction(bytes32 _hash, address[] _to, uint256[] _amount, address _origin)`
- `newChangeTokenAddressAction(bytes32 _hash, address _tokenAddress, address _origin)`
- `newAddNewOwnerAction(bytes32 _hash, address _owner, address _origin)`
- `newDelOwnerAction(bytes32 _hash, address _owner, address _origin)`
- `vote(bytes32 _hash, address _voter)`
- `votedAction(bytes32 _hash)`
