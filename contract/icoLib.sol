/*
    Initial Coin Offering Library
    icoLib.sol
    1.2.0
*/
pragma solidity 0.4.24;

import "./ico.sol";

contract IcoLib is Ico {
    /* Constructor */
    constructor(address _owner, address _libAddress, address _tokenAddress, address _offchainUploaderAddress, address _setKYCAddress, address _setRateAddress)
        Ico(_owner, _libAddress, _tokenAddress, _offchainUploaderAddress, _setKYCAddress, _setRateAddress) public {}
    /* Externals */
    function setVesting(address _beneficiary, uint256 _amount, uint256 _startBlock, uint256 _endBlock) external forOwner {
        require( _beneficiary != 0x00 );
        thisBalance = thisBalance.add( vesting[_beneficiary].amount.sub(vesting[_beneficiary].claimedAmount) );
        if ( _amount == 0 ) {
            delete vesting[_beneficiary];
            emit VestingDefined(_beneficiary, 0, 0, 0);
        } else {
            require( _endBlock > _startBlock );
            vesting[_beneficiary] = vesting_s(
                _amount,
                _startBlock,
                _endBlock,
                0
            );
            thisBalance = thisBalance.sub( _amount );
            emit VestingDefined(_beneficiary, _amount, _startBlock, _endBlock);
        }
    }
    function claimVesting() external {
        uint256 _reward;
        bool    _subResult;
        ( _subResult, _reward ) = calcVesting(msg.sender);
        require( _subResult && _reward > 0 );
        vesting[msg.sender].claimedAmount = vesting[msg.sender].claimedAmount.add(_reward);
        require( token.transfer(msg.sender, _reward) );
    }
    function setKYC(address[] _on, address[] _off) external {
        uint256 i;
        require( msg.sender == setKYCAddress );
        for ( i=0 ; i<_on.length ; i++ ) {
            KYC[_on[i]] = true;
        }
        for ( i=0 ; i<_off.length ; i++ ) {
            delete KYC[_off[i]];
        }
    }
    function setTransferRight(address[] _allow, address[] _disallow) external forOwner {
        uint256 i;
        for ( i=0 ; i<_allow.length ; i++ ) {
            transferRight[_allow[i]] = true;
        }
        for ( i=0 ; i<_disallow.length ; i++ ) {
            delete transferRight[_disallow[i]];
        }
    }
    function setCurrentRate(uint256 _currentRate) external {
        require( msg.sender == setRateAddress );
        require( _currentRate >= currentRateM );
        currentRate = _currentRate;
    }
    function setCurrentPhase(phaseType _phase) external forOwner {
        currentPhase = _phase;
    }
    function offchainUpload(address[] _beneficiaries, uint256[] _rewards) external {
        uint256 i;
        uint256 _totalReward;
        require( msg.sender == offchainUploaderAddress );
        require( currentPhase != phaseType.pause && currentPhase != phaseType.finish );
        require( _beneficiaries.length ==  _rewards.length );
        for ( i=0 ; i<_rewards.length ; i++ ) {
            _totalReward = _totalReward.add(_rewards[i]);
            emit Brought(msg.sender, _beneficiaries[i], 0, _rewards[i]);
        }
        thisBalance = thisBalance.sub(_totalReward);
        if ( currentPhase == phaseType.privateSale1 ) {
            privateSale1Hardcap = privateSale1Hardcap.sub(_totalReward);
        } else if ( currentPhase == phaseType.privateSale2 ) {
            privateSale2Hardcap = privateSale2Hardcap.sub(_totalReward);
        }
        token.bulkTransfer(_beneficiaries, _rewards);
    }
    function buy() public payable {
        uint256 _reward;
        bool    _subResult;
        require( currentPhase == phaseType.privateSale2 || 
            currentPhase == phaseType.sales1 || 
            currentPhase == phaseType.sales2 || 
            currentPhase == phaseType.sales3 || 
            currentPhase == phaseType.sales4 || 
            currentPhase == phaseType.preFinish
        );
        require( KYC[msg.sender] );
        ( _subResult, _reward ) = calculateReward(msg.value);
        require( _reward > 0 && _subResult );
        thisBalance = thisBalance.sub(_reward);
        require( owner.send(msg.value) );
        if ( currentPhase == phaseType.privateSale1 ) {
            privateSale1Hardcap = privateSale1Hardcap.sub(_reward);
        } else if ( currentPhase == phaseType.privateSale2 ) {
            privateSale2Hardcap = privateSale2Hardcap.sub(_reward);
        }
        require( token.transfer(msg.sender, _reward) );
        emit Brought(msg.sender, msg.sender, msg.value, _reward);
    }
    /* Constants */
    function allowTransfer(address _owner) public view returns (bool _success, bool _allow) {
        return ( true, _owner == address(this) || transferRight[_owner] || currentPhase == phaseType.preFinish  || currentPhase == phaseType.finish );
    }
    function calculateReward(uint256 _input) public view returns (bool _success, uint256 _reward) {
        uint256 _amount;
        _success = true;
        if ( currentRate == 0 || _input == 0 ) {
            return;
        }
        _amount = _input.mul(1e8).mul(currentRate).div(1e18).div(currentRateM);
        if ( _amount == 0 ) {
            return;
        }
        if ( currentPhase == phaseType.privateSale1 ) {
            if        ( _amount >=  25e11 ) {
                _reward = _amount.mul(142).div(100);
            } else if ( _amount >=  10e11 ) {
                _reward = _amount.mul(137).div(100);
            } else if ( _amount >=   2e11 ) {
                _reward = _amount.mul(133).div(100);
            }
            if ( _reward > 0 && privateSale1Hardcap < _reward ) {
                _reward = 0;
            }
        } else if ( currentPhase == phaseType.privateSale2 ) {
            if        ( _amount >= 125e11 ) {
                _reward = _amount.mul(129).div(100);
            } else if ( _amount >= 100e11 ) {
                _reward = _amount.mul(124).div(100);
            } else if ( _amount >=  10e11 ) {
                _reward = _amount.mul(121).div(100);
            }
            if ( _reward > 0 && privateSale2Hardcap < _reward ) {
                _reward = 0;
            }
        } else if ( currentPhase == phaseType.sales1 ) {
            if        ( _amount >=   1e11 ) {
                _reward = _amount.mul(117).div(100);
            }
        } else if ( currentPhase == phaseType.sales2 ) {
            if        ( _amount >=   1e11 ) {
                _reward = _amount.mul(112).div(100);
            }
        } else if ( currentPhase == phaseType.sales3 ) {
            if        ( _amount >=   1e11 ) {
                _reward = _amount.mul(109).div(100);
            }
        } else if ( currentPhase == phaseType.sales4 ) {
            if        ( _amount >=   1e11 ) {
                _reward = _amount.mul(102).div(100);
            }
        } else if ( currentPhase == phaseType.preFinish ) {
            if        ( _amount >=   1e11 ) {
                _reward = _amount;
            }
        }
        if ( thisBalance < _reward ) {
            _reward = 0;
        }
    }
    function calcVesting(address _owner) public view returns(bool _success, uint256 _reward) {
        vesting_s memory _vesting = vesting[_owner];
        if ( _vesting.amount == 0 || block.number < _vesting.startBlock ) {
            return ( true, 0 );
        }
        _reward = _vesting.amount.mul( block.number.sub(_vesting.startBlock) ).div( _vesting.endBlock.sub(_vesting.startBlock) );
        if ( _reward > _vesting.amount ) {
            _reward = _vesting.amount;
        }
        if ( _reward <= _vesting.claimedAmount ) {
            return ( true, 0 );
        }
        return ( true, _reward.sub(_vesting.claimedAmount) );
    }
}
