<template>
  <div class="character-wrapper">
    <CharacterImage :name="character ? character.name : undefined" />
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

</style>