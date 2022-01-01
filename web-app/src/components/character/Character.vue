<template>
  <div class="character-wrapper">
    <div
      v-if="!character"
      class="character-loader"
    >LOADER</div>
    <div
      v-if="character"
      class="character-selector"
    >
      <div
        :id="`warrior-image-${character.name.toLowerCase().split(' ')[0]}`"
        class="character-image"
      />
      <button>{{ character.name }}</button>
    </div>
  </div>
</template>

<script>

export default {
  name: 'Character',
  props: {
    character: {
      required: false,
      type: Object
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

      .character-image {
        width: 100%;
        height: 100%;
        border: 1px solid $green;
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
      
      .character-label {
        text-align: center;
      }
    }
  }

</style>