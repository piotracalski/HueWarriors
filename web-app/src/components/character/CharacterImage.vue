<template>
  <div class="character-image-wrapper">
    <Loader v-if="!name" />
    <div
      v-else
      :id="`character-image-${name.toLowerCase().split(' ').join('-')}`"
      class="character-image"
    />
  </div>
</template>

<script>
import { defineComponent } from 'vue'
import Loader from '../common/Loader.vue'

export default defineComponent({
  name: 'CharacterImage',
  components: {
    Loader
  },
  props: {
    name: {
      required: false,
      type: String
    }
  }
})
</script>

<style lang="scss" scoped>

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
      
      &#character-image-red-warrior {
        background-image: url('../../assets/images/warrior-red.png');
      }
      
      &#character-image-green-warrior {
        background-image: url('../../assets/images/warrior-green.png');
      }
      
      &#character-image-blue-warrior {
        background-image: url('../../assets/images/warrior-blue.png');
      }

      &#character-image-lurid-giant {
        background-image: url('../../assets/images/lurid-giant.png');
      }
    }
  }

</style>