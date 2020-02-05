<template>
  <div id="dashboard-content">
    <div id="sidebar-content">
      <router-link class="sidebar-item" tag="div" to="/sessions">Sessions</router-link>
      <router-link class="sidebar-item" tag="div" to="/my-profile">My profile</router-link>
    </div>
    <div id="subview-container">
      <router-view />
    </div>
    <Modal v-if="$store.state.currentModalName" />
  </div>
</template>

<script>
import Modal from "./subviews/Modal.vue";

export default {
  components: { Modal },
  mounted: function() {
    this.$store.subscribe((mutation, state) => {
      if (mutation.type == "addErrors") {
        mutation.payload.forEach(err => {
          this.$toasted.global.api_error({
            message: err
          });
        });
      }
    });
  }
};
</script>

<style scoped>
#dashboard-content {
  display: grid;
  grid-template-columns: 250px 1fr;
  grid-column-gap: 30px;
}
div.sidebar-item {
  margin: 5px;
  padding: 10px 10px;
  border-radius: 10px;
}
.router-link-active {
  background-color: aliceblue;
}
.sidebar-item:hover {
  cursor: pointer;
  background-color: cyan;
}
</style>