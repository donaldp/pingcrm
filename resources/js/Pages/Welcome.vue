<template>
  <div class="container">
    <div class="content">
      <div class="logo">
        <img src="/formidable.png" />
      </div>

      <div class="welcome">
        <h4>Yey! You have successfully created a new Formidable project.</h4>
      </div>

      <div class="information">
        Formidable v{{ formidableVersion ?? "undefined" }} (Node {{ nodeVersion ?? "undefined" }})
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    formidableVersion: String,
    nodeVersion: String,
  },
};
</script>
