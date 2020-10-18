<template>
  <div id="app">
    <Test />
<!--    <Home />-->
  </div>
</template>

<script>
// import Home from './components/Home.vue'
import Test from './components/Test.vue'
import './firebase'

export default {
  name: 'App',
  components: {
    Test
    // Home
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  /*margin-top: 60px;*/
}
</style>
