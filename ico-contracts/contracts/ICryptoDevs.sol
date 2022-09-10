// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

interface ICryptoDevs {
    /**
    * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
    * Use along with {balanceOf} to enumerate all of `owners`'s tokens
     */

     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns(uint256 tokenId);

     /**
     * @dev Returns the number of tokens in `owners` account
      */
      function balanceOf(address owner) external view returns (uint256 balance);
}