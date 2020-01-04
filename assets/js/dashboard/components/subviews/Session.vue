<template>
  <div id="session-container">
    <table>
      <tr>
        <td>{{ session.name }}</td>
      </tr>
    </table>
    <a href="session.link">{{ session.link }}</a>
    <span>Vote count: {{ session.voteCount }}</span>
    <div>
      <button>Info</button>
      <button class="warning" v-if="!isPermanent">End</button>
    </div>
  </div>
</template>

<script>
export default {
  props: ["session"],
  computed: {
    isPermanent: function() {
      const userName = this.$store.getters.userId;
      const urlParts = this.session.link.split("/");
      const urlId = urlParts[urlParts.length - 1];
      return userName === urlId;
    }
  }
};
</script>

<style scoped>
#session-container {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
</style>
