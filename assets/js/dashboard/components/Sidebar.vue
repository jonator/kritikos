<template>
  <div id="sidebar-content">
    <div
      class="sidebar-item"
      v-for="sidebaritem in sidebaritems"
      :key="sidebaritem.id"
      :class="{active: sidebaritem.id === selecteditemindex}"
      v-on:click="$emit('handleclick', sidebaritem.id)"
    >{{sidebaritem.title}}</div>
  </div>
</template>

<script>
export default {
  props: {
    selecteditemindex: Number,
    sidebaritems: Array
  }
};
</script>

<style scoped>
.sidebar-item {
  margin: 5px;
  padding: 10px 10px;
  border-radius: 10px;
}
.sidebar-item:hover {
  cursor: pointer;
  background-color: cyan;
}
.sidebar-item.active {
  background-color: aliceblue;
}
</style>