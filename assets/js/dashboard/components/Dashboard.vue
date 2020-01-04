<template>
  <div id="dashboard-content">
    <Sidebar
      :sidebaritems="sidebarItems"
      :selecteditemindex="currentSubViewIndex"
      @handleclick="sidebarItemClicked"
    />
    <keep-alive>
      <component class="subview" v-bind:is="currentSubView"></component>
    </keep-alive>
  </div>
</template>

<script>
import MyProfile from "./subviews/MyProfile.vue";
import Sessions from "./subviews/Sessions.vue";
import Sidebar from "./Sidebar.vue";

export default {
  components: { MyProfile, Sessions, Sidebar },
  data: function() {
    return {
      currentSubViewIndex: 0,
      sidebarItems: [
        { id: 0, component: "MyProfile", title: "My Profile" },
        { id: 1, component: "Sessions", title: "Sessions" }
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