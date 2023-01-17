<template>
  <div id="app">
    <div><PokeGenerator/></div>
  </div>
</template>

<script>
import PokeGenerator from './components/Pokemon-Generator.vue'

export default {
  name: 'app',
  components: {
    PokeGenerator,
  }
}
</script>

<style>
#app {
    width: 450px;
    /*height: 100vh; */
    margin: auto;
    text-align: center;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    /*max-height: 100%; 
    overflow-y: scroll; */
} 
</style>
