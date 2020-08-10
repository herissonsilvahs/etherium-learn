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

interface ERC20 {
  function totalSupply() external view returns (uint);
  function balanceOf(address tokenOwner) external view returns (uint balance);
  function allowance(address tokenOwner, address spender) external view returns (uint remaining);
  function transfer(address to, uint tokens) external returns (bool success);
  function approve(address spender, uint tokens) external returns (bool success);
  function transferFrom(address from, address to, uint tokens) external returns (bool success);

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract BasicToken is Ownable, ERC20 {
  using SafeMath for uint;

  uint internal _totalSupply;

  mapping(address => uint) _balances;
  mapping(address => mapping(address => uint)) _allowed;

  function transfer(address to, uint tokens) public override returns (bool success) {
    require(_balances[msg.sender] >= tokens, "Insuficient tokens!");
    require(to != address(0), "Invalid address!");

    _balances[msg.sender] = _balances[msg.sender].sub(tokens);
    _balances[to] = _balances[to].add(tokens);

    emit Transfer(msg.sender, to, tokens);

    return true;
  }

  function totalSupply() public override view returns (uint) {
    return _totalSupply;
  }

  function balanceOf(address tokenOwner) public override view returns (uint balance) {
    return _balances[tokenOwner];
  }

  function approve(address spender, uint tokens) public override returns (bool success) {
    _allowed[msg.sender][spender] = tokens;
    emit Approval(msg.sender, spender, tokens);
    return true;
  }

  function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
    return _allowed[tokenOwner][spender];
  }

  function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
    require(_allowed[from][msg.sender] >= tokens, "Insuficient tokens!");
    require(_balances[from] >= tokens, "Insuficient tokens!");
    require(to != address(0), "Invalid address!");

    _balances[from] = _balances[from].sub(tokens);
    _balances[to] = _balances[to].add(tokens);
    _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(tokens);

    emit Transfer(from, to, tokens);

    return true;
  }
}

contract BasicDescentralizedToken is BasicToken {
  using SafeMath for uint;

  string public constant name = "BasicDescentralizedToken";
  string public constant symbol = "BDC";
  uint8 public constant decimals = 18;

  event Mint(address indexed to, uint tokens);

  function mint(address to, uint tokens) onlyOwner public {
    _balances[to] = _balances[to].add(tokens);
    _totalSupply = _totalSupply.add(tokens);

    emit Mint(to, tokens);
  }
}
