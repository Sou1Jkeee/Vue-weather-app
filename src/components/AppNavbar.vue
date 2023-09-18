<template>
  <nav class="navbar navbar-expand-md navbar-dark bg-dark">
      <div class="container-fluid">
        <a href="/" class="navbar-brand">{{ title }}</a>
      </div>
  </nav>
</template>

<script>
export default {
  name: 'AppNavbar',
  props: {
    title: String
  }
}
</script>
