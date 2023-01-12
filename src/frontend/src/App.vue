<template>
  <PokeGenerator/>
</template>

<script>
import PokeGenerator from './components/Pokemon-Generator.vue'

export default {
  name: 'App',
  components: {
    PokeGenerator
  }
}
</script>

<style>
#app {
    width: 400px;
    height: 100vh;
    margin: auto;
    text-align: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}
</style>
