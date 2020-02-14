<template>
  <div id="dashboard">
    <header>
      <div id="header-container">
        <div id="menu-button">
          <i class="gg-menu"></i>
        </div>
        <span id="logo">Kritikos</span>
        <div id="action-area">
          <span id="email">{{ $store.state.userRecord.email }}</span>
          <button v-on:click="logout">Log out</button>
        </div>
      </div>
    </header>
    <div id="dashboard-content">
      <div id="sidebar-content">
        <router-link class="sidebar-item" tag="div" to="/sessions">Sessions</router-link>
        <router-link class="sidebar-item" tag="div" to="/sessions-overview">Sessions overview</router-link>
        <router-link class="sidebar-item" tag="div" to="/my-profile">My profile</router-link>
      </div>
      <div id="subview-container">
        <router-view />
      </div>
      <Modal v-if="$store.state.currentModalName" />
    </div>
  </div>
</template>

<script>
import Modal from "./subviews/Modal.vue";

export default {
  components: { Modal },
  methods: {
    logout: function() {
      this.$store.dispatch("LOG_OUT");
    }
  },
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
header {
  height: 100px;
  width: 100vw;
}

#menu-button {
  display: none;
  padding: 27px;
}

button {
  margin: 0;
}

#header-container {
  padding: 25px;
  display: flex;
  justify-content: space-between;
}

#action-area {
  padding: 6px;
}

@media screen and (max-width: 680px) {
  #logo {
    display: none;
  }
  #menu-button {
    display: inline;
  }
}

#dashboard-content {
  height: calc(100vh - 120px - 1px);
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

.gg-menu {
  transform: scale(var(--ggs, 1));
}
.gg-menu,
.gg-menu::after,
.gg-menu::before {
  box-sizing: border-box;
  position: relative;
  display: block;
  width: 20px;
  height: 2px;
  border-radius: 3px;
  background: currentColor;
}
.gg-menu::after,
.gg-menu::before {
  content: "";
  position: absolute;
  top: -6px;
}
.gg-menu::after {
  top: 6px;
}
</style>