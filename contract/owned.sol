/*
    Contract owner
    owned.sol
    1.0.0
*/
pragma solidity 0.4.24;

contract Owned {
    /* Variables */
    address public owner = msg.sender;
    /* Constructor */
    constructor(address _owner) public {
        owner = _owner;
    }
    /* Externals */
    function replaceOwner(address _owner) external returns(bool success) {
        require( isOwner() );
        owner = _owner;
        return true;
    }
    /* Internals */
    function isOwner() internal view returns(bool) {
        return owner == msg.sender;
    }
    /* Modifiers */
    modifier forOwner {
        require( isOwner() );
        _;
    }
}
