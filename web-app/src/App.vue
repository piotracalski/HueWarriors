<template>
  <main>
    <transition name="mode-fade" mode="out-in">
      <section v-if="loading">
        <div>LOADER</div>
      </section>
      <section v-else>
        <div
          v-if="!currentAccount"
          class="container-centered"
        >
          <h1 class="heading-main">Hue Warriors</h1>
          <button @click="connectWallet">Connect Your Wallet to Play the Game</button>
        </div>
        <SelectCharacter v-else-if="currentAccount && !characterNFT"/>
      </section>
    </transition>
  </main>
</template>

<script lang="ts">
import { defineComponent, reactive, toRefs, onMounted } from 'vue';
import SelectCharacter from './components/views/SelectCharacter.vue'

declare global {
  interface Window {
    ethereum:any;
  }
} 

export default defineComponent({
  name: 'App',
  components: {
    SelectCharacter
  },
  setup() {

    const state = reactive({
      loading: true,
      currentAccount: undefined,
      characterNFT: undefined
    })

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

        return
      } catch (error) {
        console.log(error)
      }
    }

    const connectWallet = async () => {
      state.loading = true
      try {
        const { ethereum } = window
        if (!ethereum) {
          alert("Get MetaMask!")
          return
        }
        const accounts = await ethereum.request({ method: "eth_requestAccounts" })
        console.log("Connected", accounts[0])
        state.currentAccount = accounts[0]
        state.loading = false
      } catch (error) {
        console.log(error)
      }
    }

    onMounted(async () => {
      await checkIfWalletIsConnected()
      state.loading = false
    })

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
