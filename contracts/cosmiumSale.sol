pragma solidity ^0.4.25;
import "./cosmium.sol";

contract CosmiumICO is Cosmium {
    address public admin;
    address public deposit;

    //token price in wei: 1 CMQ = 0.001 Ether | 1 Ether = 1000 CMQ
    uint tokenPrice = 1000000000000000;
    
    //300 Ether
    uint hardCap = 300000000000000000000;
    
    uint public raisedAmount;
    
    uint public saleStart = now;
    uint public saleEnd = now + 604800; // one week
    uint public coinTradeStart = saleEnd + 604800; //trading begins one week after ICO sale 
    
    uint public maxInvest = 5000000000000000000;
    uint public minInvest = 1000000000000000;
    
    enum State{beforeStart, running, afterEnd, halted}
    State public icoState;
    
    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }
    
    event Invest(address investor, uint value, uint tokens);
    
    constructor(address _deposit) public {
        deposit = _deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    }
    
    //emergency stop
    function halt() public onlyAdmin {
        icoState = State.halted;
    }
    
    //restart ICO 
    function restart() public onlyAdmin {
        icoState = State.running;
    }
    
    function changeDepositAddress(address newDeposit) public onlyAdmin {
        deposit = newDeposit;
    }
    
    function getCurrentState() public view returns(State) {
        if(icoState == State.halted) { 
            return State.halted;
        } else if(block.timestamp < saleStart) {
            return State.beforeStart;
        } else if(block.timestamp >= saleStart && block.timestamp <= saleEnd) {
            return State.running;
        } else {
            return State.afterEnd;
        }
    }
    
    function invest() payable public returns(bool) {
        icoState = getCurrentState();
        require(icoState == State.running);
        
        require(msg.value >= minInvest && msg.value <= maxInvest);
        
        uint tokens = msg.value / tokenPrice;
        
        require(raisedAmount + msg.value <= hardCap);
        raisedAmount += msg.value;
        
        balances[msg.sender] += tokens;
        balances[founder] -= tokens;
        
        deposit.transfer(msg.value);
        
        emit Invest(msg.sender, msg.value, tokens);
        
        return true;
    }
    
    function burn() public returns(bool) {
        icoState = getCurrentState();
        require(icoState == State.afterEnd);
        balances[founder] = 0;
    }
    
    function() payable public {
        invest();
    }
    
    function transfer(address to, uint tokens) public returns(bool) {
        require(block.timestamp > coinTradeStart);
        super.transfer(to, tokens);
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns(bool) {
        require(block.timestamp > coinTradeStart);
        super.transferFrom(_from, _to, _value);
    }
}

