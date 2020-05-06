<template>
  <div id="sessions-overview-container">
    <h2>Data from all sessions</h2>
    <tags-filters />
    <div id="sessions-overview-wrapper">
      <VotesBarchart :votes="votes" />
      <Feedback :votes="votes" />
    </div>
  </div>
</template>

<script>
import VotesBarchart from "../charts/VotesBarchart.vue";
import Feedback from "../subviews/Feedback.vue";
import TagsFilters from "./TagsFilters.vue";

export default {
  components: { VotesBarchart, Feedback, TagsFilters },
  computed: {
    votes: function() {
      return this.$store.getters.filteredSessions.reduce(
        (acc, s) => acc.concat(s.votes),
        []
      );
    }
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
