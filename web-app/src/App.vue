<template>
  <main>
    <transition name="mode-fade" mode="out-in">
      <section v-if="loading">
        <Loader />
      </section>
      <section v-else>
        <div
          v-if="!currentAccount"
          class="container-centered"
        >
          <h1 class="heading-main">Hue Warriors</h1>
          <button @click="connectWallet">Connect Your Wallet to Play the Game</button>
        </div>
        <div
          v-else
          class="container-centered"
        >
          <SelectCharacter v-if="!characterNFT.name" @character-minted="setCharacterNFT" />
          <Arena v-else :characterNFT="characterNFT" @character-purity-change="setCharacterPurity" />
        </div>
      </section>
    </transition>
  </main>
</template>

<script lang="ts">
import {
  defineComponent,
  reactive,
  toRefs,
  onMounted,
  watch
} from 'vue'
import Loader from './components/common/Loader.vue'
import SelectCharacter from './components/views/SelectCharacter.vue'
import Arena from './components/views/Arena.vue'

import { ethers } from 'ethers'

import contractConfig from './utils/contractConfig.json'
import { contractAddress } from './utils/constants'
import { transformCharacterData } from './utils/methods'

declare global {
  interface Window {
    ethereum:any;
  }
}

export default defineComponent({
  name: 'App',
  components: {
    Loader,
    SelectCharacter,
    Arena
  },
  setup() {

    const state = reactive({
      
      loading: true,
      currentAccount: undefined,
      // hasNFT: false,
      // characterNFT: Object()
      characterNFT: {
        // name: 'test'
        purity: Number()
      }
    })

    const checkNetwork = async () => {      
      try { 
        if (window.ethereum.networkVersion !== '4') {
          alert("Please connect to Rinkeby!")
        }
      } catch(error) {
        console.log(error)
      }
    }

    const checkIfWalletIsConnected = async () => {

      try {
        const { ethereum } = window

        if (!ethereum) {
          console.log('Make sure you have MetaMask!')
        } else {
          console.log('We have the ethereum object', ethereum)

          const accounts = await ethereum.request({ method: 'eth_accounts' })

          if (accounts.length !== 0) {
            const account = accounts[0]
            console.log('Found an authorized account:', account)
            state.currentAccount = account
          } else {
            console.log('No authorized account found')
          }
        }
      } catch (error) {
        console.log(error)
        state.loading = false
      }
      return
    }

    const connectWallet = async () => {
      state.loading = true
      try {
        const { ethereum } = window
        if (!ethereum) {
          alert("Get MetaMask!")
        }
        const accounts = await ethereum.request({ method: "eth_requestAccounts" })
        console.log("Connected", accounts[0])
        state.currentAccount = accounts[0]
        // state.loading is set to false in watch()
      } catch (error) {
        console.log(error)
        state.loading = false
      }
      return
    }

    const setCharacterNFT = (characterNFT: any) => {
      console.log('setCharacterNFT', characterNFT);
      
      state.characterNFT = characterNFT
    }

    const setCharacterPurity = (value: number) => {
      state.characterNFT.purity = value
    }

    onMounted(async () => {
      await checkIfWalletIsConnected()
      await checkNetwork()
      state.loading = false
    })

    watch(
      () => state.currentAccount,
      async (currentAccount) => {
        if (currentAccount) {
          console.log(`Current account: ${currentAccount}`)
          console.log('Checking for Character NFT on address:', currentAccount)

          const provider = new ethers.providers.Web3Provider(window.ethereum)
          const signer = provider.getSigner()
          const gameContract = new ethers.Contract(
            contractAddress,
            contractConfig.abi,
            signer
          )

          const txn = await gameContract.checkIfUserHasNFT()
          if (txn.name) {
            console.log('User has character NFT')
            state.characterNFT = transformCharacterData(txn)
          } else {
            console.log('No character NFT found')
          }
        }
        state.loading = false
      }
    )

    return {
      ...toRefs(state),
      checkIfWalletIsConnected,
      connectWallet,
      setCharacterNFT,
      setCharacterPurity
    }
  }
});
</script>

<style lang="scss">

#app {
  width: 100%;
  height: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background-image: url('./assets/backgrounds/h-logo.svg');
  background-position: center;
  background-size: 90% 90%;
  background-repeat: no-repeat;
}
</style>
