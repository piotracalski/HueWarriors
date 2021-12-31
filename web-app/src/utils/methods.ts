export function transformCharacterData(characterData: any) {
  return {
    name: characterData.name,
    imageURI: characterData.imageURI,
    purity: characterData.purity.toNumber(),
    maxPurity: characterData.maxPurity.toNumber(),
    attackStrength: characterData.attackStrength.toNumber(),
    criticalHitChance: characterData.criticalHitChance.toNumber(),
  }
}