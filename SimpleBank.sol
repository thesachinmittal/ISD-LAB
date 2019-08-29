pragma solidity ^0.5.0;

contract SimpleBank {

    mapping (address => uint) private balance;   
    mapping (address => bool) public customer;
    address public manager;

   event Customer(address accountAddress);
   event Deposit(address accountAddress ,uint amount);
   event LogWithdrawal(address accountAddress ,uint withdrawAmount ,uint newBalance);


   function() external payable   {
       msg.sender.transfer(msg.value);
   }
   
    constructor() public{
       manager = msg.sender;
   }
   
   function getBalance() public memberOnly view returns(uint){
       return balance[msg.sender];
    }
   
   function add(address  accountAddress) public restricted {
    require(customer[accountAddress] == false , "SimpleBank::add: Customer is already a member of the bank");
    customer[accountAddress] = true;
    balance[accountAddress] = 0;
    emit Customer(accountAddress);
    }
    
   function deposit() public payable memberOnly returns(uint){
       balance[msg.sender] += msg.value;
       return balance[msg.sender];
       emit Deposit(msg.sender ,  msg.value);
   }

   function withdraw(uint amount) public memberOnly returns(uint){
       require(amount <= balance[msg.sender]);
       balance[msg.sender] -= amount;
       msg.sender.transfer(amount);
       return balance[msg.sender];
       emit LogWithdrawal(msg.sender , amount , balance[msg.sender]);
   }
   
   modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    modifier memberOnly() {
        require(customer[msg.sender] == true);
        _;
    }
}
   