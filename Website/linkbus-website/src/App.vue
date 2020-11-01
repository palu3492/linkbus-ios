<template>
  <div id="app">
    <b-container class="px-0">
      <h1 id="title" class="mt-2">Linkbus</h1>
      <Home />
    </b-container>
  </div>
</template>

<script>
import Home from './components/Home.vue'

export default {
  name: 'App',
  components: {
    Home
  }
}
</script>

<style>
  #app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    color: #2c3e50;
  }
  #title {
    text-align: center;
  }
</style>
