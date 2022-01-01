<template>
  <div class="container-centered">
    <h1 class="heading-secondary">Select Your Character</h1>
    <div id="characters-wrapper">
      <Character
        v-for="(character, index) in characters"
        :key="character ? character.name : index"
        :character="character ? character : undefined"
      />
    </div>
  </div>
</template>

<script>
import { defineComponent, toRefs, reactive, onMounted } from 'vue'
import Character from '../character/Character.vue'

import { ethers } from 'ethers'

import contractConfig from '../../utils/contractConfig.json'
import { contractAddress } from '../../utils/constants'
import { transformCharacterData } from '../../utils/methods'

export default defineComponent({
  name: 'SelectCharacter',
  components: {
    Character
  },
  setup() {
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

    onMounted(async () => {
      state.gameContract = await getGameContract()
      console.log(state.gameContract)
      console.log(state.characters)
      state.characters = await getCharacters()
      console.log(state.characters)
    })

    return {
      ...toRefs(state)
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