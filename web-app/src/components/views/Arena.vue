<template>
  <div>{{characterNFT.name}}</div>
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

    onMounted(async () => {
      state.gameContract = await getGameContract()
    })

    return {
      ...toRefs(state)
    }
  }
})
</script>

<style lang="scss">

</style>