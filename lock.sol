// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC721/IERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC721/utils/ERC721Holder.sol";

contract SimpleNFTTransfer is ERC721Holder {
    event TokenLocked(uint tokenId, address sender, address addressInChainB);

    /**
     * @notice Transfer any NFT to this contract
     * @dev User must approve this contract first using ERC721.approve()
     */
    function transferNFTToContract(
        address _nftContract,
        address addressInChainB,
        uint256 _tokenId
    ) external returns (bool) {
        IERC721 nft = IERC721(_nftContract);
        
        // Check if user owns the NFT
        require(nft.ownerOf(_tokenId) == msg.sender, "Not NFT owner");
        
        // Transfer NFT to this contract
        nft.safeTransferFrom(msg.sender, address(this), _tokenId);
        
        emit TokenLocked(_tokenId, msg.sender, addressInChainB);
        return true;
    }
    
    /**
     * @notice Transfer NFT from this contract to any address
     */
    function transferNFTFromContract(
        address _nftContract,
        address _to,
        uint256 _tokenId
    ) external returns (bool) {
        IERC721 nft = IERC721(_nftContract);
        
        // Check if contract owns the NFT
        require(nft.ownerOf(_tokenId) == address(this), "Contract doesn't own this NFT");
        
        // Transfer NFT to destination
        nft.safeTransferFrom(address(this), _to, _tokenId);
        
        return true;
    }
    
    /**
     * @notice Check NFT ownership
     */
    function checkNFTOwnership(
        address _nftContract, 
        uint256 _tokenId
    ) external view returns (address) {
        return IERC721(_nftContract).ownerOf(_tokenId);
    }
}
