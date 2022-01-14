<template>
  <div class="character-wrapper">
    <CharacterImage :name="character ? character.name : undefined" />
    <div class="character-label">{{ character ? character.name : 'Loading character' }}</div>
    <div class="purity-bar">Purity: {{ character ? `${character.purity} / ${character.maxPurity}` : undefined }}</div>
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

</style>