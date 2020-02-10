<template>
  <div id="sessions-overview-container">
    <h2>Vote & feedback data from all sessions</h2>
    <div id="sessions-overview-wrapper">
      <VotesBarchart :votes="votes" />
      <Feedback :votes="votes" />
    </div>
  </div>
</template>

<script>
import VotesBarchart from "../charts/VotesBarchart.vue";
import Feedback from "../subviews/Feedback.vue";

export default {
  components: { VotesBarchart, Feedback },
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

<style scoped>
#sessions-overview-container {
  max-width: 1000px;
}
#sessions-overview-wrapper {
  display: grid;
  gap: 30px;
  grid-template-columns: 1fr 1fr;
}
@media screen and (max-width: 1150px) {
  #sessions-overview-wrapper {
    display: grid;
    gap: 30px;
    grid-template-columns: 1fr;
    grid-template-rows: auto;
  }
}
</style>
