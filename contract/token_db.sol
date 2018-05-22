/*
    Token database
    token_db.sol
    1.0.1
*/
pragma solidity 0.4.24;

import "./safeMath.sol";
import "./owned.sol";

contract TokenDB is Owned {
    /* Declarations */
    using SafeMath for uint256;
    /* Structures */
    // struct vesting_s {
    //     address giver;
    //     uint256 amount;
    //     uint256 start;
    //     uint256 end;
    //     uint256 received;
    // }
    /* Variables */
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(address => uint256) public balances;
    // mapping(address => vesting_s[]) public vestings;
    address public tokenAddress;
    /* Constructor */
    /* Externals */
    function changeTokenAddress(address _tokenAddress) external forOwner {
        tokenAddress = _tokenAddress;
    }
    function transfer(address _from, address _to, uint256 _amount) external forToken returns(bool _success) {
        balances[_from] = balances[_from].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
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
        return ( true, balances[_owner]);
    }
    // function vestingBalanceOf(address _owner) public view returns (bool _success, uint256 _value) {
    // }
    /* Modifiers */
    modifier forToken {
        if ( tokenAddress == 0x00 ) {
            tokenAddress = msg.sender;
        }
        require( msg.sender == tokenAddress );
        _;
    }
}
