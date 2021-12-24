// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract HueWarriors {

  struct CharacterAttributes {
    uint characterIndex;
    string name;
    string imageURI;        
    uint purity;
    uint maxPurity;
    uint attackStrength;
    uint criticalHitChance;
  }

  CharacterAttributes[] defaultCharacters;

  constructor(
    string[] memory characterNames,
    string[] memory characterImageURIs,
    uint[] memory characterPurity,
    uint[] memory characterStrength,
    uint[] memory criticalHitChance
  ) {
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
      console.log("Done initializing %s w/ HP %s, img %s", c.name, c.hp, c.imageURI);
    }
    console.log("HueWarriors constructed.");
  }
}