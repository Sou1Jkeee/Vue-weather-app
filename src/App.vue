<template>
  <Navbar title="Weather App"/>
  <div class="d-flex justify-content-center">
    <Weather/>
  </div>
</template>

<script>
import Navbar from './components/AppNavbar.vue'
import Weather from './components/AppWeather.vue'

export default {
  props: {
  },
  name: 'App',
  components: {
    Navbar,
    Weather,
  }
}

</script>

<style>
  body {
    background-color: var(--bs-gray-dark);
  }
</style>
