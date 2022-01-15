<template>
  <div class="container-centered">
    <h1 class="heading-secondary">The Arena</h1>
    <div id="arena-wrapper">
      <div id="boss-wrapper" class="arena-element arena-character-wrapper">
        <ArenaCharacter :character="boss"/>
      </div>
      <div id="vs-wrapper" class="arena-element">VS</div>
      <div id="character-wrapper" class="arena-element arena-character-wrapper">
        <ArenaCharacter :character="characterNFT" />
      </div>
    </div>
    <button @click="runAttackAction">
      <span v-if="attacking" class="loading">Attacking</span>
      <span v-else>Attack!</span>
    </button>
  </div>
</template>

<script>
import { defineComponent, reactive, toRefs, onMounted } from 'vue'
import ArenaCharacter from '../character/ArenaCharacter.vue'

import { ethers } from 'ethers'

import contractConfig from '../../utils/contractConfig.json'
import { contractAddress } from '../../utils/constants'
import { transformCharacterData } from '../../utils/methods'

export default defineComponent({
  name: 'Arena',
  emits: ['character-purity-change'],
  components: {
    ArenaCharacter,
  },
  props: {
    characterNFT: {
      type: Object,
      required: true
    }
  },
  setup(props, ctx) {

    const state = reactive({
      gameContract: null,
      boss: null,
      attacking: false,
      playerPurity: undefined
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
        )
        gameContract.on('AttackComplete', onAttackComplete)
        return gameContract
      } else {
        console.log('Ethereum object not found')
        return null
      }
    }

    const fetchBoss = async () => {
      const bossTxn = await state.gameContract.getBoss()
      // console.log('Boss:', bossTxn)
      return transformCharacterData(bossTxn)
    }

    const runAttackAction = async () => {
      try {
        if (!state.attacking && state.gameContract) {
          state.attacking = true
          console.log('Attacking boss...')
          const attackTxn = await state.gameContract.attackBoss()
          await attackTxn.wait()
          console.log('attackTxn:', attackTxn)
        }
      } catch (error) {
        console.error('Error attacking boss:', error)
        state.attacking = false
      }
    }

     const onAttackComplete = (newBossPurity, newPlayerPurity) => {
        const bossPurity = newBossPurity.toNumber()
        const playerPurity = newPlayerPurity.toNumber()

        console.log(`AttackComplete: Boss Purity: ${bossPurity} Player Purity: ${playerPurity}`)

        state.boss.purity = bossPurity
        ctx.emit('character-purity-change', playerPurity)
        state.attacking = false
      }

    onMounted(async () => {
      state.gameContract = await getGameContract()

      if (state.gameContract.address) state.boss = await fetchBoss()
    })

    return {
      ...toRefs(state),
      runAttackAction
    }
  }
})
</script>

<style lang="scss">

  #arena-wrapper {
    width: 50vw;
    height: 50vh;
    display: grid;
    grid-template-columns: 1fr auto 1fr;
    grid-template-rows: 1fr;
    gap: 10rem;
    // background-color: red;

    .arena-element {
      place-self: center;

      &.arena-character-wrapper {
        width: 100%;
        height: 100%;
        // background-color: green;
      }
    }

    #vs-wrapper {
      font-size: 6rem;
      font-weight: bold;
      color: red;
      text-shadow: 0 0 10px rgb(232, 232, 232);
    }
  }

</style>