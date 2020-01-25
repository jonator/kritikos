<template>
  <div id="session-container">
    <table>
      <tr>
        <td>
          <h3>{{ session.keyword }}</h3>
        </td>
        <td />
      </tr>
      <tr>
        <td>Session identifier</td>
        <td>{{ session.link }}</td>
      </tr>
      <tr>
        <td>Vote count</td>
        <td>{{ session.voteCount }}</td>
      </tr>
      <tr v-if="session.promptQuestion != null">
        <td>Custom prompt question</td>
        <td>{{ session.promptQuestion }}</td>
      </tr>
      <tr>
        <td>Start time</td>
        <td>{{ session.startDatetime }}</td>
      </tr>
      <tr v-if="session.endDatetime">
        <td>End time</td>
        <td>{{ session.endDatetime }}</td>
      </tr>
      <tr>
        <td>Tags</td>
        <td>
          <div v-for="tag in session.tags" :key="tag.id">{{ tag.text }}</div>
        </td>
      </tr>
    </table>
    <VotesBarchart :votes="session.votes" />
  </div>
</template>

<script>
import VotesBarchart from "../charts/VotesBarchart.vue";

export default {
  props: ["sessionId"],
  components: { VotesBarchart },
  computed: {
    session: function() {
      return this.$store.state.sessions.find(s => {
        return s.id == this.sessionId;
      });
    }
  }
};
</script>
