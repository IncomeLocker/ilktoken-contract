/*
    Token Library
    tokenLib.sol
    1.1.0
*/
pragma solidity 0.4.24;

import "./token.sol";
import "./tokenDB.sol";

contract TokenLib is Token {
    /* Constructor */
    constructor(address _owner, address _libAddress, address _dbAddress, address _icoAddress) Token(_owner, _libAddress, _dbAddress, _icoAddress) public {}
    /* Externals */
    function approve(address _spender, uint256 _amount) external returns (bool _success) {
        _approve(_spender, _amount);
        return true;
    }
    function transfer(address _to, uint256 _amount) external returns (bool _success) {
        _transfer(msg.sender, _to, _amount);
        return true;
    }
    function bulkTransfer(address[] _to, uint256[] _amount) external returns (bool _success) {
        uint256 i;
        require( _to.length == _amount.length );
        require( db.bulkTransfer(msg.sender, _to, _amount) );
        for ( i=0 ; i<_to.length ; i++ ) {
            require( _amount[i] > 0 && _to[i] != 0x00 && msg.sender != _to[i] );
            emit Transfer(msg.sender, _to[i], _amount[i]);
        }
        return true;
    }
    function transferFrom(address _from, address _to, uint256 _amount) external returns (bool _success) {
        bool    _subResult;
        uint256 _reamining;
        if ( _from != msg.sender ) {
            (_subResult, _reamining) = db.getAllowance(_from, msg.sender);
            require( _subResult );
            _reamining = _reamining.sub(_amount);
            require( db.setAllowance(_from, msg.sender, _reamining) );
            emit AllowanceUsed(msg.sender, _from, _amount);
        }
        _transfer(_from, _to, _amount);
        return true;
    }
    /* Constants */
    function allowance(address _owner, address _spender) public view returns (uint256 _remaining) {
        bool _subResult;
        (_subResult, _remaining) = db.getAllowance(_owner, _spender);
        require( _subResult );
    }
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        bool _subResult;
        (_subResult, _balance) = db.balanceOf(_owner);
        require( _subResult );
    }
    /* Internals */
    function _transfer(address _from, address _to, uint256 _amount) internal {
        require( _amount > 0 && _from != 0x00 && _to != 0x00 && _from != _to );
        require( db.transfer(_from, _to, _amount) );
        emit Transfer(_from, _to, _amount);
    }
    function _approve(address _spender, uint256 _amount) internal {
        require( msg.sender != _spender );
        require( db.setAllowance(msg.sender, _spender, _amount) );
        emit Approval(msg.sender, _spender, _amount);
    }
}
