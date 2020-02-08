<template>
  <div id="sessions-overview-container">
    <h2>Vote & feedback data from all sessions</h2>
    <VotesBarchart :votes="votes" />
  </div>
</template>

<script>
import VotesBarchart from "../charts/VotesBarchart.vue";

export default {
  components: { VotesBarchart },
  data: function() {
    return {
      votes: this.$store.state.sessions.reduce(
        (acc, s) => acc.concat(s.votes),
        []
      )
    };
  }
};
</script>
