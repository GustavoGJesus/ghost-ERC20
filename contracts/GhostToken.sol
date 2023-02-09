// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GhostToken is ERC20{
  //private variables
  uint256 private _totalSuply;

  //functions that the user needs
  //name of mapping is balances and stores the values ​​of each portfolio in addres that recived a data of type uint256
  //stores balance of users 
  mapping(address => uint256) private _balances;

  //stores information that a user gives to a third party, example: DEX
  //exemplo: my address -> address third party -> value of tokens
        //   0xGSY2635  ->      binance        ->  700 SOL
  mapping(address => mapping(address => uint256)) private _allowances;

  //a event emits information off the blockchain
  //indexed is for filters, if i want to search all the addresses of that specific wallet I can do it because of indexed
  //event Transfer(address indexed _from, address indexed _to, uint256 _value);
  //event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  //add values of variables
  constructor(uint256 initialSupply) ERC20("Gustavo Token", "GTK"){
    _mint(msg.sender, initialSupply);
  }

  //functions for reading variables privates
  function decimals() public override pure returns(uint8){
    return 6;
  }

  function totalSuply() public  view returns(uint256){
    return _totalSuply;
  }

  //return balance of wallet (owner wallet)
  function balanceOf(address _owner) public override view returns(uint256){
    return _balances[_owner];
  }

  //receive two values: address of wallet and amount of token. And return a boolean
  function transfer(address recipient, uint256 amount) public override returns (bool){
    _transfer(msg.sender, recipient, amount);
    return true;
  }

  function transferFrom(address sender, address recipient, uint256 amount) public override returns(bool){
      uint256 currentAllowance = _allowances[sender][msg.sender];
      require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");

      _transfer(sender, recipient, amount);
      _approve(sender, msg.sender, currentAllowance - amount);
      
      return true;
  }

  function approve(address spender, uint256 amount) public override returns(bool){
      _approve(msg.sender, spender, amount);
      return true;  
  }

  //queries the amount of authorizations that already exist plus how much I'm providing now and it will pass to the approve function  
  function increaseAllowance(address spender, uint256 addedValue) public override returns(bool){
      _approve(msg.sender, spender, _allowances[msg.sender][spender] += addedValue);
      return true;  
  }

  function decreaseAllowance(address spender, uint256 subtractedValue) public override returns(bool){
    uint256 currentAllowance = _allowances[msg.sender][spender];
    require(currentAllowance >= subtractedValue, "ERC20: decreased allowance belo zero");

    unchecked{    
        _approve(msg.sender, spender, currentAllowance - subtractedValue);
    }

    return true;
  }
  
  //owner = my address, spender = binance, amount = amount of tokes 
  function _approve(address owner, address spender, uint256 amount) internal override{
      _allowances[owner][spender] = amount;

      emit Approval(owner, spender, amount);
  }

  function _transfer(address sender, address recipient, uint256 amount) internal override{
    //check if the balace sender exists in _balances (dicionary), if exists storaged in senderBalance variable
    uint256 senderBalance =  _balances[sender];
    //check if the balace sender exists in _balances, if not exists return a error: "ERC20: transfer amount exeeds balance"
    require(senderBalance >= amount, "ERC20: transfer amount exeeds balance");

    //update the sending balance before updating the receiving 
    //unchecked = checks if the number is within that 256 bits, so as not to overflow
    unchecked{ 
      _balances[sender] = senderBalance - amount; 
    }

    //if exists return the balance with address of recipient and sum with value amount
    _balances[recipient] += amount;

    //emit event of transfer that received three parameters, sender, recipient and amount
    emit Transfer(sender, recipient, amount);
  }

  function _mint(address account, uint256 amount) internal override {
      _totalSuply += amount;
      _balances[account] += amount;

      emit Transfer(address(0), account, amount);
  }

}