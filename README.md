# ERC20contractAssignment
This is my ERC20 Contract Assignment...where I take "My First ERC20 Contract" and modify it to have a 1% transaction fee and then deploy it using Sepolia as instructed in the ZTM Blockchain Developer Course.

### Assignment: 
- Extend the ERC20 contract with one function
- Add a 1% fee to the transfer function. The fee will be added to the balance of an address defined in the Smart Contract state
- First deploy it to a local blockchain in Remix. Use our giveMeOneFullToken function. And test if the fee works. Then try to deploy this contract via Remix on a public testate, e.g. Sepolia

<br>  

> [!NOTE]
> Check out my ERC20 "1% Transaction Fee" Contract Deployed with Sepolia
> on [Etherscan](https://sepolia.etherscan.io/tx/0x2451f9fff426a51e6d6982eddb171febc1274d123958d410f58efbe74d3a1bd3)
<br>
<br>

## What my ERC20 "1% Transaction Fee" Contract does line by line:  

#### ✅ Identifier & Compiler  
``` // SPDX-License-Identifier: MIT ```\
**License identifier** – tells developers and tools what license this code uses (MIT in this case, which is permissive and open-source).

``` pragma solidity 0.8.26; ```\
**Compiler version** – this tells Solidity to compile with version 0.8.26. If a different version is used, compilation will fail.

#### 📝 Contract  
``` contract ERC20 { ```  
Start of the contract definition – I'm creating a contract called ERC20.

#### 🔔 Events   
``` 
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);
```
**Events** – these log important actions on the blockchain. They're used for: \
``` Transfer ```: when tokens move from one account to another \
``` Approval ```: when someone allows another account to spend tokens on their behalf.

#### 🏷️ Token Metadata  
```
 string constant public name = "MyTokenName"; 
 string constant public symbol = "MTN"; 
 uint8 constant public decimals = 18; 
```
These are public constants that define basic token metadata:\
``` name ```: Full name of my token.\
``` symbol ```: Token symbol (like ETH or USDT).\
``` decimals ```: How divisible my token is. 18 means 1 token = 1e18 smallest units, like Ether.  

#### 📊 Token Supply & Balances  
``` 
uint256 public totalSupply; 
mapping (address => uint256) public balanceOf; 
mapping (address => mapping(address => uint256)) public allowance;
``` 
``` totalSupply ```: Tracks the total number of tokens minted.  
``` balanceOf ```: Keeps track of how many tokens each address owns.  
``` allowance ```: Lets users approve another address to spend tokens on their behalf (used in transferFrom).  

#### 💸 Transfer Function
```
    function transfer(address to, uint256 value) external returns (bool) {
    return _transfer(msg.sender, to, value);
}
```
This is the standard ERC-20 ```transfer``` function.  
It lets the sender (caller) send tokens to another address.  
Calls the internal ```_transfer()``` function to handle the logic.  

#### 🎁 Minting Tokens (Testing)
```
function giveMeOneToken() external {
    balanceOf[msg.sender] += 1e18;
}
```
This is a custom function for testing.  
It mints 1 full token (1e18 units) to the caller's address.  

#### 🏦 Transfer Using Allowance  
```
function transferFrom(address from, address to, uint256 value) external returns (bool) {
    require(allowance[from][msg.sender] >= value, "ERC20: Insufficient Allowance"); 
    
    allowance[from][msg.sender] -= value;
    
    emit Approval(from, msg.sender, allowance[from][msg.sender]);

    return _transfer(from, to, value);
}
```
This allows a third party (like a smart contract) to transfer tokens on behalf of someone else.  
It checks that the sender (```msg.sender```) is allowed to spend that much.  
It deducts the allowance and calls ```_transfer()``` to complete the move.  

#### ⚙️ Internal Transfer Logic
```
function _transfer(address from, address to, uint256 value) private returns (bool) {
    require(balanceOf[from] >= value, "ERC20: Insufficient sender balance");

    emit Transfer(from, to, value);

    balanceOf[from] -= value;
    balanceOf[to] += value;

    return true;
}
```
This is the core transfer logic:  
Checks the sender has enough tokens.  
Emits the ```Transfer``` event.  
Moves tokens from sender to recipient.  

#### ✅ Approval Function
```
function approve(address spender, uint256 value) external returns (bool) {
    allowance[msg.sender][spender] += value;

    emit Approval(msg.sender, spender, value);

    return true;
}
```
Allows another address ```(spender)``` to spend a certain amount of your tokens.
This is needed for ```transferFrom()``` to work.

#### 📌 Summary  

This is a simple ERC-20 implementation with:  
Basic token data (```name```, ```symbol```, ```decimals```)  
Token balances and transfers  
Allowance system for third-party transfers  
A test function to mint tokens  

