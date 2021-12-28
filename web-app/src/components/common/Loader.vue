<template>
  <div id="loader" />
</template>

<script>
import { defineComponent } from 'vue';

export default defineComponent({
  name: 'Loader'
})
</script>

<style lang="scss" scoped>
  #loader {
    width: 100%;
    height: 100%;
    background: radial-gradient(circle, rgba(255,255,255,0.2) 0%, rgba(0,0,0,0) 100%);
    background-size: 100% 100%;
    animation: loader-gradient 3s ease-in infinite;

    @keyframes loader-gradient {
      0% {
        opacity: .8;
      }
      50% {
        opacity: .1;
      }
      100% {
        opacity: .8;
      }
    }
  }
</style>