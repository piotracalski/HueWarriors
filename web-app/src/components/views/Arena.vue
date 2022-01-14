<template>
  <div class="container-centered">
    <h1 class="heading-secondary">The Arena</h1>
    <div id="arena-wrapper">
      <div id="boss-wrapper" class="arena-element">BOSS</div>
      <div id="vs-wrapper" class="arena-element">VS</div>
      <div id="character-wrapper" class="arena-element">{{characterNFT.name}}</div>
    </div>
  </div>
</template>

<script>
import { defineComponent, reactive, toRefs, onMounted } from 'vue'

import { ethers } from 'ethers'

import contractConfig from '../../utils/contractConfig.json'
import { contractAddress } from '../../utils/constants'
import { transformCharacterData } from '../../utils/methods'

export default defineComponent({
  name: 'Arena',
  props: {
    characterNFT: {
      type: Object,
      required: true
    }
  },
  setup() {

    const state = reactive({
      gameContract: null,
      boss: null
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

    const fetchBoss = async () => {
      const bossTxn = await state.gameContract.getBoss()
      console.log('Boss:', bossTxn)
      return transformCharacterData(bossTxn)
    }

    onMounted(async () => {
      state.gameContract = await getGameContract()

      if (state.gameContract.address) state.boss = await fetchBoss()
    })

    return {
      ...toRefs(state)
    }
  }
})
</script>

<style lang="scss">

  #arena-wrapper {
    width: 70vw;
    height: 50vh;
    display: grid;
    grid-template-columns: 1fr auto 1fr;
    grid-template-rows: 1fr;
    // background-color: red;

    .arena-element {
      // width: 100%;
      // height: 100%;
      place-self: center;
      // background-color: green;
    }

    #vs-wrapper {
      font-size: 6rem;
      font-weight: bold;
      color: red;
      text-shadow: 0 0 10px rgb(232, 232, 232);
    }
  }

</style>