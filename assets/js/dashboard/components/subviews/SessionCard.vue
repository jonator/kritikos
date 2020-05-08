<template>
  <div id="session-card-container">
    <table>
      <tr>
        <td v-if="session.name">
          <b>{{ session.name }}</b>
        </td>
        <td v-else>
          <b>{{ session.keyword }}</b>
        </td>
      </tr>
    </table>
    <a v-bind:href="session.link" target="_blank">{{ session.link }}</a>
    <span v-if="session.votes != null">Vote count: {{ session.votes.length }}</span>
    <span v-else>Keyword: {{ session.keyword }}</span>
    <div id="button-wrapper">
      <button v-on:click="$router.push('/sessions/'+session.keyword)">results</button>
      <button
        class="warning"
        v-if="!session.isEnded"
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
#button-wrapper {
  display: inline-flex;
  justify-content: space-evenly;
}
#button-wrapper button {
  margin: 0;
}
</style>
