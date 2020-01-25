<template>
  <div id="session-container">
    <div id="actions">
      <button v-on:click="$router.push('/sessions')">back</button>
      <div id="session-actions">
        <button v-if="!session.endDatetime" class="warning" v-on:click="endSession">close</button>
      </div>
    </div>
    <table>
      <tr>
        <td>
          <h2>{{ session.keyword }}</h2>
        </td>
        <td />
      </tr>
      <tr>
        <td>Public link</td>
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
        <td>Start date/time</td>
        <td>{{ session.startDatetime }}</td>
      </tr>
      <tr v-if="session.endDatetime">
        <td>End date/time</td>
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
  components: { VotesBarchart },
  data: function() {
    return {
      session: this.$store.state.sessions.find(s => {
        return s.keyword == this.$route.params.keyword;
      })
    };
  },
  methods: {
    endSession: function() {
      this.$store.dispatch("END_SESSION", this.session.keyword);
    }
  },
  beforeRouteUpdate(to, from, next) {
    this.$store
      .dispatch("FETCH_SESSION", { keyword: to.params.keyword })
      .then(() => {
        this.session = this.$store.state.sessions.find(s => {
          return s.keyword == to.params.keyword;
        });
        next();
      })
      .catch(() => next(false));
  }
};
</script>

<style scoped>
#session-container {
  max-width: 1000px;
}
#actions {
  padding-bottom: 30px;
  display: grid;
  grid-template-columns: 100px 1fr;
  gap: 30px;
}
#session-actions {
  display: inline-flex;
  justify-content: flex-end;
}
#session-actions button {
  margin-left: 10px;
}
</style>
