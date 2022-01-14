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

  struct Boss {
    string name;
    string imageURI;
    uint purity;
    uint maxPurity;
    uint attackStrength;
    uint criticalHitChance;
  }

  Boss public boss;

  // NFTs unique identifier
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  CharacterAttributes[] defaultCharacters;

  // nft's tokenId => that NFTs attributes.
  mapping(uint256 => CharacterAttributes) public nftHolderAttributes;

  // address => the NFTs tokenId
  mapping(address => uint256) public nftHolders;

  event CharacterNFTMinted(address sender, uint256 tokenId, uint256 characterIndex);
  event AttackComplete(uint newBossPurity, uint newPlayerPurity);

  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterPurity,
    uint[] memory characterStrength,
    uint[] memory criticalHitChance,
    string memory bossName,
    string memory bossImageURI,
    uint bossPurity,
    uint bossAttackStrength,
    uint bossCriticalHitChance
  )
    ERC721("HueWarriors", "HUWA")
  {
    boss = Boss({
      name: bossName,
      imageURI: bossImageURI,
      purity: bossPurity,
      maxPurity: bossPurity,
      attackStrength: bossAttackStrength,
      criticalHitChance: bossCriticalHitChance
    });

    console.log("Done initializing boss %s w/ Purity %s, img %s", boss.name, boss.purity, boss.imageURI);

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
  function mintCharacterNFT(uint256 _characterIndex) external {

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

    emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);
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

  function attackBoss() public {

    // Get the state of the player's NFT.
    uint256 nftTokenIdOfPlayer = nftHolders[msg.sender];
    CharacterAttributes storage player = nftHolderAttributes[nftTokenIdOfPlayer];
    console.log("\nPlayer w/ character %s about to attack. Has %s Purity and %s AS", player.name, player.purity, player.attackStrength);
    console.log("Boss %s has %s purity and %s AS", boss.name, boss.purity, boss.attackStrength);

    // Make sure the player has more than 0 purity.
    require (
      player.purity > 0,
      "Error: character must have purity to attack boss."
    );

    // Make sure the boss has more than 0 purity.
    require (
      boss.purity > 0,
      "Error: boss must have purity to attack boss."
    );

    // Allow player to attack boss.
    if (boss.purity < player.attackStrength) {
      boss.purity = 0;
    } else {
      boss.purity = boss.purity - player.attackStrength;
    }

    // Allow boss to attack player.
    if (player.purity < boss.attackStrength) {
      player.purity = 0;
    } else {
      player.purity = player.purity - boss.attackStrength;
    }
  
    // Console for ease.
    console.log("Player attacked boss. New boss purity: %s", boss.purity);
    console.log("Boss attacked player. New player purity: %s\n", player.purity);

    emit AttackComplete(boss.purity, player.purity);
  }

  function checkIfUserHasNFT() public view returns (CharacterAttributes memory) {
    uint256 userNftTokenId = nftHolders[msg.sender];
    if (userNftTokenId > 0) {
      return nftHolderAttributes[userNftTokenId];
    }
    else {
      CharacterAttributes memory emptyStruct;
      return emptyStruct;
    }
  }

  function getAllDefaultCharacters() public view returns (CharacterAttributes[] memory) {
    return defaultCharacters;
  }

  function getBoss() public view returns (Boss memory) {
    return boss;
  }
}