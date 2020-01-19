<template>
  <div id="dashboard-content">
    <Sidebar
      :sidebaritems="sidebarItems"
      :selecteditemindex="currentSubViewIndex"
      @handleclick="sidebarItemClicked"
    />
    <div id="subview-container">
      <keep-alive>
        <component class="subview" v-bind:is="currentSubView" />
      </keep-alive>
    </div>
    <Modal v-if="$store.state.currentModalName" :innerComponent="$store.state.currentModalName" />
  </div>
</template>

<script>
import MyProfile from "./subviews/MyProfile.vue";
import Sessions from "./subviews/Sessions.vue";
import Sidebar from "./Sidebar.vue";
import Modal from "./subviews/Modal.vue";

export default {
  components: { MyProfile, Sessions, Sidebar, Modal },
  data: function() {
    return {
      currentSubViewIndex: 0,
      sidebarItems: [
        { id: 0, component: "Sessions", title: "Sessions" },
        { id: 1, component: "MyProfile", title: "My Profile" }
      ]
    };
  },
  computed: {
    currentSubView: function() {
      return this.sidebarItems[this.currentSubViewIndex].component;
    }
  },
  methods: {
    sidebarItemClicked: function(index) {
      this.currentSubViewIndex = index;
    }
  }
};
</script>

<style scoped>
#dashboard-content {
  display: grid;
  grid-template-columns: 250px 1fr;
  grid-column-gap: 30px;
}
</style>