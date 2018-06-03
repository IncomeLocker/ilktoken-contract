/*
    Token database
    tokenDB.sol
    2.0.1
*/
pragma solidity 0.4.24;

import "./safeMath.sol";
import "./owned.sol";

contract TokenDB is Owned {
    /* Declarations */
    using SafeMath for uint256;
    /* Structures */
    struct balances_s {
        uint256 amount;
        bool valid;
    }
    /* Variables */
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => balances_s) public balances;
    address public tokenAddress;
    address public oldDBAddress;
    /* Constructor */
    constructor(address _owner, address _tokenAddress, address _icoAddress, address _oldDBAddress) Owned(_owner) public {
        if ( _oldDBAddress == 0x00 ) {
            balances[_icoAddress].amount = 44e14;
        }
        oldDBAddress = _oldDBAddress;
        tokenAddress = _tokenAddress;
    }
    /* Externals */
    function changeTokenAddress(address _tokenAddress) external forOwner {
        tokenAddress = _tokenAddress;
    }
    function transfer(address _from, address _to, uint256 _amount) external forToken returns(bool _success) {
        uint256 _senderBalance = _getBalance(_from);
        uint256 _receiverBalance = _getBalance(_to);
        balances[_from].amount = _senderBalance.sub(_amount);
        balances[_to].amount = _receiverBalance.add(_amount);
        return true;
    }
    function bulkTransfer(address _from, address[] _to, uint256[] _amount) external forToken returns(bool _success) {
        uint256 _senderBalance = _getBalance(_from);
        uint256 _receiverBalance;
        uint256 i;
        for ( i=0 ; i<_to.length ; i++ ) {
            _receiverBalance = _getBalance(_to[i]);
            balances[_from].amount = _senderBalance.sub(_amount[i]);
            balances[_to[i]].amount = _receiverBalance.add(_amount[i]);
        }
        return true;
    }
    function setAllowance(address _owner, address _spender, uint256 _amount) external forToken returns(bool _success) {
        allowance[_owner][_spender] = _amount;
        return true;
    }
    /* Constants */
    function getAllowance(address _owner, address _spender) public view returns(bool _success, uint256 _remaining) {
        return ( true, allowance[_owner][_spender] );
    }
    function balanceOf(address _owner) public view returns(bool _success, uint256 _balance) {
        return ( true, _getBalance(_owner) );
    }
    /* Internals */
    function _getBalance(address _owner) internal returns(uint256 _balance) {
        if ( ( ! balances[_owner].valid ) && oldDBAddress != 0x00 ) {
            bool _subResult;
            ( _subResult, _balance ) = TokenDB(oldDBAddress).balanceOf(_owner);
            balances[_owner].amount = _balance;
            balances[_owner].valid = true;
        }
        return balances[_owner].amount;
    }
    /* Modifiers */
    modifier forToken {
        require( msg.sender == tokenAddress );
        _;
    }
}
