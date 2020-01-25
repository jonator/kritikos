<template>
  <div id="session-card-container">
    <table>
      <tr>
        <td v-if="session.name">{{ session.name }}</td>
        <td v-else>{{ session.keyword }}</td>
      </tr>
    </table>
    <a v-bind:href="session.link">{{ session.link }}</a>
    <span v-if="session.voteCount != null">Vote count: {{ session.voteCount }}</span>
    <span v-else>Keyword: {{ session.keyword }}</span>
    <div>
      <button v-on:click="$store.dispatch('SELECT_SESSION', session.id)">view</button>
      <button
        class="warning"
        v-if="!session.isPermanent && !session.isEnded"
        v-on:click="$store.dispatch('END_SESSION', session.keyword)"
      >end</button>
    </div>
  </div>
</template>

<script>
export default {
  props: ["sessionId"],
  computed: {
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
