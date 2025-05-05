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

#### 📝 Contract Declaration 
``` contract ERC20 { ```  
Starts the definition of my smart contract named ERC20

#### 🔔 Events   
``` 
event Transfer(address indexed from, address indexed to, uint256 value);
event Approval(address indexed owner, address indexed spender, uint256 value);
```
**Events** – these log important actions or "events" for the frontend dApps or for blockchain explorers to track.  
They're used for: \
``` Transfer ```: when tokens move from one account to another. emitted when tokens are sent. \
``` Approval ```: when someone allows another account to spend tokens on their behalf. emitted when a spender is approved to spend tokens.

#### 🏷️ Token Metadata  
```
 string constant public name = "MyTokenName"; 
 string constant public symbol = "MTN"; 
 uint8 constant public decimals = 18; 
```
These are public constants that define basic token metadata:\
``` name ```: Full name of my token.\
``` symbol ```: Name abbreviation. Token symbol (like ETH or USDT).\
``` decimals ```: Number of decimal places. How divisible my token is. 18 means 1 token = 1e18 smallest units, 18 is standard like Ether.  

#### 📊 Token Supply & Balances  
``` 
uint256 public totalSupply; 
mapping (address => uint256) public balanceOf; 
mapping (address => mapping(address => uint256)) public allowance;
```
**In Solidity**, a mapping is like a hash table (or dictionary) that stores key–value pairs.  
This means:  
🔑 address → 📦 uint256 (the token balance for each address)  
It's used to track data for different users efficiently.  
``` totalSupply ```: Tracks the total number of tokens minted (but not updated in this code). 
``` balanceOf ```: Keeps track of how many tokens each address owns or in other words ... keeps track of how many tokens (```owner```) lets (```spender```) spend.
``` allowance ```: Lets users approve another address to spend tokens on their behalf (used in transferFrom).  

#### 💰 Fee Address 
```
address public feeCollector = 0xA26D8AF9d02Dc35c1BC05bD46528B24b71B83d96;
```
Sets the address that will receive the 1% transaction fee.

#### 💸 Transfer Function
```
    function transfer(address to, uint256 value) external returns (bool) {
    return _transfer(msg.sender, to, value);
}
```
**A function** is a reusable block of code that performs a specific task when called.  
This is the standard ERC-20 ```transfer``` function.  
It lets the sender (caller) send tokens to another address. 
Calls the internal ```_transfer()``` function to handle the logic.  

#### 🎁 Minting Tokens (Testing for Dev)
```
function giveMeOneToken() external {
    balanceOf[msg.sender] += 1e18;
}
```
This is a custom function for testing.  
It mints 1 full token (1e18 units) to the caller's address. Good for testing only.  
⚠️ Does not increase ```totalSupply```.

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
```function transferFrom(address from, address to, uint256 value) external returns (bool) {require(allowance[from][msg.sender] >= value, "ERC20: Insufficient Allowance");``` Checks that the sender (```msg.sender```) is allowed to spend that much ```value``` tokens from ```from```.  
```allowance[from][msg.sender] -= value;``` Decreases the allowance after the spend.  
It deducts the allowance and calls ```_transfer()``` to complete the move.  
```emit Approval(from, msg.sender, allowance[from][msg.sender]);``` Emits an Approval event to reflect the updated allowance.  
```return _transfer(from, to, value); }``` Transfers the tokens using the internal ```_transfer()```.  

#### ⚙️ Internal Transfer Logic (with fee)
```
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
```
This is the core transfer logic:
Moves tokens from sender to recipient and pays the 1% fee.  
```function _transfer(address from, address to, uint256 value) private returns (bool) {require(balanceOf[from] >= value, "ERC20: Insufficient sender balance");``` Checks if the sender has enough tokens.     
```uint256 fee = value / 100; // 1% Fee``` ```uint256 amountAfterFee = value - fee;``` Calculates a 1% fee and how much the recipient will actually get. The ```100``` represents 100%, and dividing the ```value``` by 100 gives you 1% of the value. ```fee = 0.01 tokens``` — that's 1% of 1 token. ```value / 100``` = 1% of ```value```... It's just basic percentage math: value × 1 / 100 = 1%


 ```balanceOf[from] -= value;``` ```balanceOf[to] += amountAfterFee;``` ```balanceOf[feeCollector] += fee;``` Transfers the net amount to the recipient, and the fee to the ```feeCollector```.  
```emit Transfer(from, to, amountAfterFee);``` ```emit Transfer(from, feeCollector, fee);``` Emits two events:
- The main transfer
- The fee transfer
```return true;}``` Confirms the transfer succeeded.


#### ✅ Approval Function
```
function approve(address spender, uint256 value) external returns (bool) {
    allowance[msg.sender][spender] += value;

    emit Approval(msg.sender, spender, value);

    return true;
}
```
```function approve(address spender, uint256 value) external returns (bool) { allowance[msg.sender][spender] += value;``` Adds ```value``` to the amount the ```spender``` is allowed to spend from ```msg.sender```.
```emit Approval(msg.sender, spender, value); return true;}``` Emits the ```Approval``` event and confirms success.  
This is needed for ```transferFrom()``` to work.

#### 📌 Summary  

This ERC-20 1% Transaction Fee Contract:  
- Basic token data (```name```, ```symbol```, ```decimals```)  
- Token balances and transfers
- Allows transfers and approvals
- Adds a 1% fee to each transfer
- Sends the fee to a ```feeCollector``` address
- Allowance system for third-party transfers  
- Has a simple test function to mint tokens
- Does not have owner control or real mint logic yet
- Does not update ```totalSupply``` when tokens are minted

