/*
    Initial Coin Offering Proxy
    ico.sol
    2.1.0
*/
pragma solidity 0.4.24;

import "./safeMath.sol";
import "./owned.sol";
import "./token.sol";

contract Ico is Owned {
    /* Declarations */
    using SafeMath for uint256;
    /* Enumerations */
    enum phaseType {
        pause,
        privateSale1,
        privateSale2,
        sales1,
        sales2,
        sales3,
        sales4,
        preFinish,
        finish
    }
    struct vesting_s {
        uint256 amount;
        uint256 startBlock;
        uint256 endBlock;
        uint256 claimedAmount;
    }
    /* Variables */
    mapping(address => bool) public KYC;
    mapping(address => bool) public transferRight;
    mapping(address => vesting_s) public vesting;
    phaseType public currentPhase;
    uint256   public currentRate;
    uint256   public currentRateM = 1e3;
    uint256   public privateSale1Hardcap = 4e16;
    uint256   public privateSale2Hardcap = 64e15;
    uint256   public thisBalance = 44e16;
    address   public offchainUploaderAddress;
    address   public setKYCAddress;
    address   public setRateAddress;
    address   public libAddress;
    Token     public token;
    /* Constructor */
    constructor(address _owner, address _libAddress, address _tokenAddress, address _offchainUploaderAddress,
        address _setKYCAddress, address _setRateAddress) Owned(_owner) public {
        currentPhase = phaseType.pause;
        libAddress = _libAddress;
        token = Token(_tokenAddress);
        offchainUploaderAddress = _offchainUploaderAddress;
        setKYCAddress = _setKYCAddress;
        setRateAddress = _setRateAddress;
    }
    /* Fallback */
    function () public payable {
        buy();
    }
    /* Externals */
    function changeLibAddress(address _libAddress) external forOwner {
        libAddress = _libAddress;
    }
    function changeOffchainUploaderAddress(address _offchainUploaderAddress) external forOwner {
        offchainUploaderAddress = _offchainUploaderAddress;
    }
    function changeKYCAddress(address _setKYCAddress) external forOwner {
        setKYCAddress = _setKYCAddress;
    }
    function changeSetRateAddress(address _setRateAddress) external forOwner {
        setRateAddress = _setRateAddress;
    }
    function setVesting(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock) external {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0)
            }
        }
    }
    function claimVesting() external {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0)
            }
        }
    }
    function setKYC(address[] _on, address[] _off) external {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0)
            }
        }
    }
    function setTransferRight(address[] _allow, address[] _disallow) external {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0)
            }
        }
    }
    function setCurrentRate(uint256 _currentRate) external {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0)
            }
        }
    }
    function setCurrentPhase(phaseType _phase) external {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0)
            }
        }
    }
    function offchainUpload(address[] _beneficiaries, uint256[] _rewards) external {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0)
            }
        }
    }
    function buy() public payable {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0)
            }
        }
    }
    /* Constants */
    function allowTransfer(address _owner) public view returns (bool _success, bool _allow) {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0x40)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0x40)
            }
        }
    }
    function calculateReward(uint256 _input) public view returns (bool _success, uint256 _reward) {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0x40)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0x40)
            }
        }
    }
    function calcVesting(address _owner) public view returns(bool _success, uint256 _reward) {
        address _trg = libAddress;
        assembly {
            let m := mload(0x40)
            calldatacopy(m, 0, calldatasize)
            let success := delegatecall(gas, _trg, m, calldatasize, m, 0x40)
            switch success case 0 {
                revert(0, 0)
            } default {
                return(m, 0x40)
            }
        }
    }
    /* Events */
    event Brought(address _owner, address _beneficiary, uint256 _input, uint256 _output);
    event VestingDefined(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock);
    event VestingClaimed(address _beneficiary, uint256 _amount);
}
