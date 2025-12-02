// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20 {
    uint public Price; //must be in ether format (not wei)
    uint public StoredTime;
    bool public STATE;
    string public Name;
    string public Symbol;
    uint8 public constant Decimals = 6;
    uint public TotalSupply;
    address public Owner;
    uint public minOffer = 0.001 ether;
    uint public maxOffer = 1 ether;
    uint public totalPhases = 10;

    mapping(address => uint) private _balanceOf;
    mapping(address => mapping(address => uint)) private _allowances;

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);


    modifier State {
        require(STATE, "CONTRACT_IS_OFF");
        _;
    }

    modifier Timing {
        require(StoredTime > block.timestamp, "STAY_TUNED");
        _;
    }

    modifier OnlyOwner {
        require(msg.sender == Owner, "ONLY_OWNER");
        _;
    }


    constructor(string memory _name, string memory _symbol, uint _totalSupply, uint _initial_price) {
        Name = _name;
        Symbol = _symbol;
        STATE = false;
        TotalSupply = _totalSupply;
        Owner = msg.sender;
        Price = _initial_price;
        StoredTime = block.timestamp + 604_800; // for now this, but actual is when project starts the ICO
        _OnPreSale();
    }

    function _mint(uint amount) internal {
        _balanceOf[Owner] += amount;
        emit Transfer(address(0), Owner, amount);
    }

    function _afterPreSale() internal {
        require(totalPhases==0);
        _mint(TotalSupply*60/100);
    }

    function _OnPreSale() internal {
        require(totalPhases>=1);
        _mint(TotalSupply*4/100); // only 40% will be minted, each time 4% for 10 times.
    }

    function name() public view returns (string memory) {
        return Name;
    }

    function symbol() public view returns (string memory) {
        return Symbol;
    }

    function decimals() public pure returns (uint8) {
        return Decimals;
    }

    function totalSupply() public view returns (uint) {
        return TotalSupply;
    }

    function balanceOf(address _owner) public view returns (uint balance) {
        return _balanceOf[_owner];
    }

    function transfer(address _to, uint _value) public State returns (bool success) {
        bool suc = _transfer(msg.sender, _to, _value);
        return suc;
    }

    function transferFrom(address _from, address _to, uint _value) public State returns (bool) {
        require(_allowances[_from][msg.sender] >= _value, "ALLOWANCE_TOO_LOW");
        require(_balanceOf[_from] >= _value, "BALANCE_TOO_LOW");
        _allowances[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }


    function approve(address spender, uint value) public State returns (bool) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }


    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        return _allowances[_owner][_spender];
    }


    function _transfer(address sender, address recv, uint amount) internal returns (bool) {
        require(_balanceOf[sender] >= amount, "BALANCE_TOO_LOW");
        _balanceOf[sender] -= amount;
        _balanceOf[recv] += amount;
        emit Transfer(sender, recv, amount);
        return true;
    }

    function divertState() external OnlyOwner returns (bool) {
        STATE = !STATE;
        return true;
    }

    function Doubling() external OnlyOwner { // must be triggered once a week by developer.
        require(totalPhases >= 1); // ico has 10 phases (2.5 months) and after that cannot buy from contract.
        uint one_week_unix_time = 604_800;
        StoredTime += one_week_unix_time;
        Price *= 2;
        totalPhases -= 1;
        if (totalPhases!=0){
            _OnPreSale(); // will be triggered if totalPhases is more or equal to 1.
        }
        if (totalPhases==0) {
            _afterPreSale(); // the remaining 60% will be minted.
        }
    }

    receive() external payable State Timing {
        require(msg.value >= minOffer, "LESS_MIN_LIMIT");
        require(msg.value <= maxOffer, "MORE_MAX_LIMIT");
        uint recv_amount = msg.value*(10**Decimals) / Price;
        require(recv_amount > 1, "buy_more");
        require(_balanceOf[Owner]>=recv_amount);
        bool suc = _transfer(Owner, msg.sender, recv_amount);
        require(suc, "Something_went_wrong");
        (suc,) = payable(Owner).call{value: msg.value}(""); // this will be used for funding liquidity, non used by devs
        require(suc, "FAILED_TX");
    }

    function burn(uint amount) public {
        _transfer(msg.sender, address(0), amount);
        TotalSupply -= amount;
    }

}