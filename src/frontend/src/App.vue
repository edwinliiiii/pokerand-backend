<template>
  <div>
    <div class = "app2"><PokeGenerator/></div>
    <div class="app1"><Recent/></div>

  </div>
</template>

<script>
import Recent from './components/Recent-Saver.vue'
import PokeGenerator from './components/Pokemon-Generator.vue'

export default {
  name: 'app',
  components: {
    Recent,
    PokeGenerator,
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

.genButton {
  width: 150px;
  height: 35px;
  margin:auto;
  padding:auto;
  background-color:orangered;
}

.addButton {
  width: 150px;
  height: 35px;
  margin:auto;
  padding:auto;
  background-color:lightgray;
}
</style>
