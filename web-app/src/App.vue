<template>
  <header class="header-main">
    <div class="container-centered">
      <h1 class="heading-main">Hue Warriors</h1>
      <button>connect your wallet to play the game</button>
    </div>
  </header>
</template>

<script lang="ts">
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'App',
  components: {
  }
});
</script>

<style lang="scss">

#app {
  width: 100%;
  height: 100%;
  font-family: Avenir, Helvetica, Arial, sans-serif;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
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
