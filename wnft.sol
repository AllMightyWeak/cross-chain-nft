// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract MyTokenWrapped is ERC721URIStorage {
    uint256 public totalMints = 0;

    uint256 public mintPrice = 1 ether;
    uint256 public maxSupply = 50;
    uint256 public maxPerWallet = 5;
    mapping(address => uint256) public walletMints;

    constructor() ERC721("MyTokenWrapped", "MTKW") {}

    function safeMint(address to, string memory tokenURI) internal {
        uint256 tokenId = totalMints;
        totalMints++;

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
    }

    function mintToken(uint256 quantity_, string memory tokenURI) public payable {
        require(quantity_ * mintPrice == msg.value, "wrong amount sent");
        require(walletMints[msg.sender] + quantity_ <= maxPerWallet, "mints per wallet exceeded");

        walletMints[msg.sender] += quantity_;
        safeMint(msg.sender, tokenURI);
    }

    function getMyWalletMints() public view returns (uint256) {
        return walletMints[msg.sender];
    }
}