<template>
  <div class="character-wrapper">
    <CharacterImage :name="character ? character.name : undefined" />
    <div class="character-label">{{ character ? character.name : 'Loading character' }}</div>
    <div v-if="character" class="purity-bar">
      <div>Purity: {{ character ? `${character.purity} / ${character.maxPurity}` : undefined }}</div>
      <progress :max="character.maxPurity" :value="character.purity"/>
    </div>
  </div>
</template>

<script>
import { defineComponent } from 'vue'
import CharacterImage from './CharacterImage.vue'

export default defineComponent({
  name: 'ArenaCharacter',
  components: {
    CharacterImage
  },
  props: {
    character: {
      required: false,
      type: Object
    }
  }
})
</script>

<style lang="scss">

  .character-label {
    text-align: center;
    font-size: 2rem;
    margin: 1rem 0;
  }

  .purity-bar {
    width: 100%;

    progress {
      width: 100%;
      appearance: none;
    }

    progress[value]::-webkit-progress-bar {
      background-color: $red;
    }

    progress[value]::-webkit-progress-value {
      background-color: $green;
    }
  }

</style>