<template>
  <div id="session-card-container">
    <table>
      <tr>
        <td>{{ session.keyword }}</td>
      </tr>
    </table>
    <a href="session.link">{{ session.link }}</a>
    <span v-if="!isEnded">Vote count: {{ session.voteCount }}</span>
    <span v-else>SESSION ENDED</span>
    <div>
      <button v-on:click="$store.dispatch('SELECT_SESSION', session.id)">Info</button>
      <button
        class="warning"
        v-if="!session.isPermanent && !isEnded"
        v-on:click="$store.dispatch('END_SESSION', session.keyword)"
      >End</button>
    </div>
  </div>
</template>

<script>
export default {
  props: ["sessionId"],
  computed: {
    isEnded: function() {
      return this.session.endDatetime != null;
    },
    session: function() {
      return this.$store.state.sessions.find(s => s.id == this.sessionId);
    }
  }
};
</script>

<style scoped>
#session-card-container {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
</style>
