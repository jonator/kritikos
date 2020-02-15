<template>
  <div id="dashboard" v-bind:class="{ mobile: isMobile }">
    <header>
      <div id="header-container">
        <div v-if="isMobile" class="clickable" id="menu-button" v-on:click="menuVisible = true">
          <i class="gg-menu"></i>
        </div>
        <span v-if="!isMobile" id="logo">Kritikos</span>
        <div id="action-area">
          <span id="email">{{ $store.state.userRecord.email }}</span>
          <button v-if="!isMobile" v-on:click="logout">Log out</button>
        </div>
      </div>
    </header>
    <div id="dashboard-content">
      <div
        id="sidebar-content"
        v-bind:style="{ display: menuVisible || !isMobile ?  'block' : 'none' }"
        v-on:click="menuVisible = false"
      >
        <div id="sidebar-wrapper">
          <div v-if="isMobile" id="mobile-logo-wrapper">
            <span id="logo">Kritikos</span>
          </div>
          <div v-if="isMobile" class="clickable" id="menu-back-button">
            <i class="gg-undo"></i>
          </div>
          <router-link class="sidebar-item" tag="div" to="/sessions">Sessions</router-link>
          <router-link class="sidebar-item" tag="div" to="/sessions-overview">Sessions overview</router-link>
          <router-link class="sidebar-item" tag="div" to="/my-profile">My profile</router-link>
          <div class="sidebar-item" v-if="isMobile" v-on:click="logout">Log out</div>
        </div>
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

const mobileThresholdPixels = 680;

export default {
  components: { Modal },
  data: function() {
    return {
      menuVisible: false,
      size: { width: 0, height: 0 }
    };
  },
  computed: {
    isMobile: function() {
      return this.size.width < mobileThresholdPixels;
    }
  },
  methods: {
    handleResize: function() {
      this.size.width = window.innerWidth;
      this.size.height = window.innerHeight;
    },
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
    window.addEventListener("resize", this.handleResize);
    this.handleResize();
  }
};
</script>

<style scoped>
#dashboard-content {
  height: calc(100vh - 120px - 1px);
  display: grid;
  grid-template-columns: 250px 1fr;
  grid-column-gap: 30px;
}

.mobile #sidebar-content {
  position: fixed;
  left: 0;
  top: 0;
  width: 100vw;
  height: 100vh;
  z-index: 9999;
}
.mobile #sidebar-wrapper {
  background-color: white;
}
.mobile #dashboard-content {
  grid-template-columns: 1fr;
  margin-left: 10px;
}

header {
  height: 100px;
  width: 100vw;
}

#menu-button {
  padding: 27px;
}

#menu-back-button {
  height: 50px;
  margin: auto;
  padding-top: 20px;
}
#menu-back-button i {
  margin: auto;
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

#mobile-logo-wrapper {
  width: 100%;
  height: 50px;
  padding-left: 5%;
  padding-top: 10px;
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

/* icons */
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
.gg-undo {
  box-sizing: border-box;
  position: relative;
  display: block;
  transform: scale(var(--ggs, 1));
  width: 14px;
  height: 14px;
  border: 2px solid;
  border-left-color: transparent;
  border-radius: 100px;
}
.gg-undo::before {
  content: "";
  display: block;
  box-sizing: border-box;
  position: absolute;
  width: 6px;
  height: 6px;
  border-top: 2px solid;
  border-left: 2px solid;
  top: -3px;
  left: -1px;
  transform: rotate(-68deg);
}
</style>