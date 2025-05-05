//SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    string constant public name = "MyTokenName";
    string constant public symbol = "MTN";
    uint8 constant public decimals = 18;

    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;

    mapping (address => mapping(address => uint256)) public allowance;

    address public feeCollector = 0xA26D8AF9d02Dc35c1BC05bD46528B24b71B83d96; // Replace with your desired address

    function transfer(address to, uint256 value) external returns (bool) {
        
        return _transfer(msg.sender, to, value);
    }

    function giveMeOneToken() external {
        balanceOf[msg.sender] += 1e18;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(allowance[from][msg.sender] >= value, "ERC20: Insufficient Allowance"); 
        
        allowance[from][msg.sender] -= value;
        
        emit Approval(from, msg.sender, allowance[from][msg.sender]);

        return _transfer(from, to, value);
    }

    function _transfer(address from, address to, uint256 value) private returns (bool) {
        require(balanceOf[from] >= value, "ERC20: Insufficient sender balance");

        uint256 fee = value / 100; // 1% Fee
        uint256 amountAfterFee = value - fee;

        balanceOf[from] -= value;
        balanceOf[to] += amountAfterFee;
        balanceOf[feeCollector] += fee;

        emit Transfer(from, to, amountAfterFee);
        emit Transfer(from, feeCollector, fee);

    

        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] += value;

        emit Approval(msg.sender, spender, value);

        return true;
    }
}