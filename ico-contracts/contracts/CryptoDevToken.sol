// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ICryptoDevs.sol";

contract CryptoDevToken is ERC20, Ownable {
    uint256 public constant tokenPrice = 0.001 ether;

    uint256 public constant tokensPerNFT = 10 * 10**18;

    uint public constant maxTotalSupply = 10000 * 10**18;

    ICryptoDevs CryptoDevsNFT;

    mapping(uint256 => bool) public tokenIdsClaimed;

    constructor(address _cryptoDevsContract) ERC20("Crypto Dev Token", "CD") {
        CryptoDevsNFT = ICryptoDevs(_cryptoDevsContract);
    }

    /**
    * @dev Mints `amount` number of CrryptoDevToken
    * Reqirements
    * -`msg.value`should be equal or greater than tokenPrice * amount
     */
     function mint(uint256 amount) public payable {
         uint256 _requiredAmount = tokenPrice * amount;
         require(msg.value >= _requiredAmount, "Ether sent is incorrect");
         
         uint256 amountWithDecimals = amount * 10**18;
         require(totalSupply() + amountWithDecimals <= maxTotalSupply, "Exceeds the maximum total supply available");

         _mint(msg.sender, amountWithDecimals);
         
     }

     /** 
     * @dev mints tokens based on the number of NFTs held by the sender
     * Requirements
     * balance of Crypto Dev NFT's owned by the sender must be greater than zero
     * tokens should not have been claimed for all the NFT's owned by the sender
      */
      function claim() public {
          address sender = msg.sender;
          uint256 balance = CryptoDevsNFT.balanceOf(sender);

          require(balance > 0, "You dont own any CryptoDevsNFT");

          uint256 amount = 0;
          
          for(uint i = 0; i < balance; i++) {
              uint256 tokenId = CryptoDevsNFT.tokenOfOwnerByIndex(sender, i);
              if(!tokenIdsClaimed[tokenId]) {
                  amount += 1;
                  tokenIdsClaimed[tokenId] = true;
              }
          }

          require(amount > 0, "You have already claimed all the tokens");

          _mint(msg.sender, amount * tokensPerNFT);
      }

      receive() external payable {}

      fallback() external payable {}

}