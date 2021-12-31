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
        <SelectCharacter v-else-if="currentAccount && !hasNFT"/>
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

import contractConfig from './utils/contractConfig.json'
import { transformCharacterData } from './utils/methods'
import { ethers } from 'ethers'

declare global {
  interface Window {
    ethereum:any;
  }
}

export default defineComponent({
  name: 'App',
  components: {
    Loader,
    SelectCharacter
  },
  setup() {

    const state = reactive({
      contractAddress: '0xfA102d423cCAE86301A9e90c7f9DD94D4401c657',
      loading: true,
      currentAccount: undefined,
      hasNFT: false,
      characterNFT: Object()
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
            state.contractAddress,
            contractConfig.abi,
            signer
          )

          const txn = await gameContract.checkIfUserHasNFT()
          console.log(txn)
          if (txn.name) {
            console.log('User has character NFT')
            state.characterNFT = transformCharacterData(txn)
            state.hasNFT = true
          } else {
            console.log('No character NFT found')
            state.hasNFT = false
            state.characterNFT = {}
          }
        }
        state.loading = false
      }
    )

    return {
      ...toRefs(state),
      checkIfWalletIsConnected,
      connectWallet
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

.warrior-image-wrapper {
  /* width: 500px;
  height: 500px;
  padding: 3rem; */
  /* red */
  /* background: radial-gradient(circle, rgba(171,115,115,1) 0%, rgba(107,60,60,1) 100%); */
  /* green */
  /* background: radial-gradient(circle, rgba(115,171,141,1) 0%, rgba(60,107,72,1) 100%); */
  /* blue */
  /* background: radial-gradient(circle, rgba(115,119,171,1) 0%, rgba(60,62,107,1) 100%); */
  /* lurid giant */
  /* background: radial-gradient(circle, rgba(149,149,149,1) 0%, rgba(93,93,93,1) 100%); */
}
</style>
