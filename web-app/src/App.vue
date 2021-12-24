<template>
  <!-- <img alt="Vue logo" src="./assets/logo.png"> -->
  <!-- <HelloWorld msg="Welcome to Your Vue.js + TypeScript App"/> -->
  <div id="test">
    <WarriorImage />
  </div>
</template>

<script lang="ts">
import { defineComponent } from 'vue';
// import HelloWorld from './components/HelloWorld.vue';
import WarriorImage from './components/warrior/WarriorImage.vue';

export default defineComponent({
  name: 'App',
  components: {
    WarriorImage
  }
});
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

#test {
  width: 500px;
  height: 500px;
  /* background-color: rgb(204, 203, 143); */
  padding: 3rem;
  /* red */
  /* background: radial-gradient(circle, rgba(171,115,115,1) 0%, rgba(107,60,60,1) 100%); */
  /* green */
  /* background: radial-gradient(circle, rgba(115,171,141,1) 0%, rgba(60,107,72,1) 100%); */
  /* blue */
  background: radial-gradient(circle, rgba(115,119,171,1) 0%, rgba(60,62,107,1) 100%);
}
</style>
