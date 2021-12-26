// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// NFT contract to inherit from.
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// Helper functions OpenZeppelin provides.
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

import "./libraries/Base64.sol";

import "hardhat/console.sol";

contract HueWarriors is ERC721 {

  struct CharacterAttributes {
    uint characterIndex;
    string name;
    string imageURI;        
    uint purity;
    uint maxPurity;
    uint attackStrength;
    uint criticalHitChance;
  }

  // NFTs unique identifier
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  CharacterAttributes[] defaultCharacters;

  // nft's tokenId => that NFTs attributes.
  mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

  // address => the NFTs tokenId
  mapping(address => uint256) public nftHolders;

  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterPurity,
    uint[] memory characterStrength,
    uint[] memory criticalHitChance
  )
    ERC721("HueWarriors", "HUWA")
  {
    for(uint i = 0; i < characterNames.length; i += 1) {
      defaultCharacters.push(CharacterAttributes({
        characterIndex: i,
        name: characterNames[i],
        imageURI: characterImageURIs[i],
        purity: characterPurity[i],
        maxPurity: characterPurity[i],
        attackStrength: characterStrength[i],
        criticalHitChance: criticalHitChance[i]
      }));

      CharacterAttributes memory c = defaultCharacters[i];
      console.log("Done initializing %s w/ Purity %s, img %s", c.name, c.purity, c.imageURI);
    }

    // increment tokenIds here so that first NFT has an ID of 1
    _tokenIds.increment();

    console.log("HueWarriors araised.");
  }

  // Users would be able to hit this function and get their NFT based on the characterId they send in
  function mintCharacterNFT(uint _characterIndex) external {

    // Get current tokenId (starts at 1 since we incremented in the constructor).
    uint256 newItemId = _tokenIds.current();

    // Assign the tokenId to the caller's wallet address.
    _safeMint(msg.sender, newItemId);

    // We map the tokenId => their character attributes
    nftHolderAttributes[newItemId] = CharacterAttributes({
      characterIndex: _characterIndex,
      name: defaultCharacters[_characterIndex].name,
      imageURI: defaultCharacters[_characterIndex].imageURI,
      purity: defaultCharacters[_characterIndex].purity,
      maxPurity: defaultCharacters[_characterIndex].maxPurity,
      attackStrength: defaultCharacters[_characterIndex].attackStrength,
      criticalHitChance: defaultCharacters[_characterIndex].criticalHitChance
    });

    console.log("Minted NFT w/ tokenId %s and characterIndex %s", newItemId, _characterIndex);
    
    // see who owns what NFT.
    nftHolders[msg.sender] = newItemId;

    // Increment the tokenId for the next person that uses it.
    _tokenIds.increment();
  }

  function tokenURI(uint256 _tokenId) public view override returns (string memory) {
    CharacterAttributes memory charAttributes = nftHolderAttributes[_tokenId];

    string memory strPurity = Strings.toString(charAttributes.purity);
    string memory strMaxPuriy = Strings.toString(charAttributes.maxPurity);
    string memory attackStrength = Strings.toString(charAttributes.attackStrength);

    string memory json = Base64.encode(
      abi.encodePacked(
        '{"name": "',
        charAttributes.name,
        ' -- NFT #: ',
        Strings.toString(_tokenId),
        '", "description": "This is an NFT that lets people play in the game Hue Warriors!", "image": "',
        charAttributes.imageURI,
        '", "attributes": [ { "trait_type": "Purity Points", "value": ',strPurity,', "max_value":',strMaxPuriy,'}, { "trait_type": "Attack Strength", "value": ',
        attackStrength,'} ]}'
      )
    );

    string memory output = string(
      abi.encodePacked("data:application/json;base64,", json)
    );
    
    return output;
  }
}