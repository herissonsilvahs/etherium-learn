pragma solidity 0.7.0;

library SafeMath {
  function add(uint a, uint b) internal pure returns(uint) {
    uint c = a + b;
    require(c >= a, "Sum overflow!");
    return c;
  }
  function sub(uint a, uint b) internal pure returns(uint) {
    uint c = a - b;
    require(c <= a, "Sub underflow!");
    return c;
  }
  function mul(uint a, uint b) internal pure returns(uint) {
    if(a == 0) {
      return 0;
    }
    uint c = a * b;
    require(c / a == b, "Mul overflow!");
    return c;
  }
  function div(uint a, uint b) internal pure returns(uint) {
    uint c = a / b;
    return c;
  }
}

contract Ownable {
  address public owner;

  event OwnershipTransferred(address newOwner);

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, 'You are not the owner!');
    _;
  }

  function transferOwnership(address payable newOwner) onlyOwner public {
    owner = newOwner;
    emit OwnershipTransferred(owner);
  }
}

contract BasicDescentralizedToken is Ownable {
  using SafeMath for uint;

  string public constant name = "BasicDescentralizedToken";
  string public constant symbol = "BDC";
  uint8 public constant decimals = 18;
  uint public totalSupply;

  mapping(address => uint) balances;

  event Mint(address indexed to, uint tokens);
  event Transfer(address indexed from, address indexed to, uint tokens);

  function mint(address to, uint tokens) onlyOwner public {
    balances[to] = balances[to].add(tokens);
    totalSupply = totalSupply.add(tokens);

    emit Mint(to, tokens);
  }

  function transfer(address to, uint tokens) public {
    require(balances[msg.sender] >= tokens, "Insuficient tokens!");
    require(to != address(0), "Invalid address!");

    balances[msg.sender] = balances[msg.sender].sub(tokens);
    balances[to] = balances[to].add(tokens);

    emit Transfer(msg.sender, to, tokens);
  }
}