<template>
  <div class="character-wrapper">
    <div class="character-selector">
      <div class="character-image-wrapper">
        <Loader v-if="!character" />
        <div
          v-if="character"
          :id="`warrior-image-${character.name.toLowerCase().split(' ')[0]}`"
          class="character-image"
        />
      </div>
      <button @click="$emit('mint-character', index)">{{ character ? character.name : 'Loading character' }}</button>
    </div>
  </div>
</template>

<script>
import Loader from '../common/Loader.vue'

export default {
  name: 'Character',
  emits: ['mint-character'],
  components: {
    Loader
  },
  props: {
    character: {
      required: false,
      type: Object
    },
    index: {
      required: true,
      type: Number
    }
  }
}
</script>

<style lang="scss">

  .character-wrapper {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: flex-end;

    .character-selector {
      width: 100%;
      height: 100%;
      display: grid;
      grid-template-columns: 1fr;
      grid-template-rows: 1fr auto;
      gap: 2rem;

      &:hover {
        .character-image-wrapper {
          .character-image {
            // image animation goes here
          }
        }
      }

      .character-image-wrapper {
        width: 100%;
        height: 100%;
        border: 1px solid $green;

        .character-image {
          width: 100%;
          height: 100%;
          background-position: center;
          background-repeat: no-repeat;
          background-size: cover;
          
          &#warrior-image-red {
            background-image: url('../../assets/images/warrior-red.png');
          }
          
          &#warrior-image-green {
            background-image: url('../../assets/images/warrior-green.png');
          }
          
          &#warrior-image-blue {
            background-image: url('../../assets/images/warrior-blue.png');
          }
        }
      }

      .character-label {
        text-align: center;
      }
    }
  }

</style>