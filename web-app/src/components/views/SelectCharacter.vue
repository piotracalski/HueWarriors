<template>
  <div class="container-centered">
    <h1 class="heading-secondary">Select Your Character</h1>
    <div id="characters-wrapper">
      <Character
        v-for="(character, index) in characters"
        :key="character ? character.name : index"
        :character="character ? character : undefined"
        :index="index"
        @mint-character="mintCharacterNFTAction"
      />
    </div>
  </div>
</template>

<script>
import { defineComponent, toRefs, reactive, onMounted, onUnmounted } from 'vue'
import Character from '../character/Character.vue'

import { ethers } from 'ethers'

import contractConfig from '../../utils/contractConfig.json'
import { contractAddress } from '../../utils/constants'
import { transformCharacterData } from '../../utils/methods'

export default defineComponent({
  name: 'SelectCharacter',
  emits: ['character-minted'],
  components: {
    Character
  },
  setup(props, ctx) {
    const state = reactive({
      characters: Array(3),
      gameContract: null
    })

    const getGameContract = async () => {

      const { ethereum } = window

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const gameContract = new ethers.Contract(
          contractAddress,
          contractConfig.abi,
          signer
        );
        gameContract.on('CharacterNFTMinted', onCharacterMint)
        return gameContract
      } else {
        console.log('Ethereum object not found')
        return null
      }
    }

    const getCharacters = async () => {

      try {
        console.log('Getting contract characters to mint');

        // Call contract to get all mint-able characters
        const charactersTxn = await state.gameContract.getAllDefaultCharacters()
        console.log('charactersTxn:', charactersTxn)

        // Go through all of our characters and transform the data
        const characters = charactersTxn.map((characterData) =>
          transformCharacterData(characterData)
        )

        // Set all mint-able characters in state
        return characters

      } catch (error) {
        console.error('Something went wrong fetching characters:', error)
      }
    }

    const mintCharacterNFTAction = async (characterId) => {
      console.log(characterId);
      try {
        if (state.gameContract.address) {
          console.log('Minting character in progress...');
          const mintTxn = await state.gameContract.mintCharacterNFT(characterId);
          await mintTxn.wait();
          console.log('mintTxn:', mintTxn);
          ctx.emit('character-minted', mintTxn)
        }
      } catch (error) {
        console.warn('MintCharacterAction Error:', error);
      }
    }

    const onCharacterMint = async (sender, tokenId, characterIndex) => {

      const txn = await state.gameContract.checkIfUserHasNFT()
      console.log('CharacterNFT: ', characterNFT)
      const characterNFT = transformCharacterData(txn)

      ctx.emit('character-minted', characterNFT)
      alert(`Your NFT is all done -- see it here: https://testnets.opensea.io/assets/${sender}/${tokenId.toNumber()}`)
    }

    onMounted(async () => {
      state.gameContract = await getGameContract()
      state.characters = await getCharacters()
    })

    onUnmounted(() => {
      // below should be fixed but it's not
      // state.gameContract.off('CharacterNFTMinted', onCharacterMint)
    })

    return {
      ...toRefs(state),
      mintCharacterNFTAction
    }
  }
})
</script>

<style lang="scss">

  #characters-wrapper {
    width: 70vw;
    height: 50vh;
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    grid-template-rows: 1fr;
    gap: 5rem;
  }

</style>