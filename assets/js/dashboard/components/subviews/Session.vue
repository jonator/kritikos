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
        <td id="public-link-cell">
          <a v-bind:href="session.link">{{ session.link }}</a>
          <ExportSessionButton :sessionKeyword="session.keyword" />
        </td>
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
    <div id="data-display-container">
      <VotesBarchart :votes="session.votes" />
      <Feedback :votes="session.votes" />
    </div>
  </div>
</template>

<script>
import VotesBarchart from "../charts/VotesBarchart.vue";
import ExportSessionButton from "../ExportSessionButton.vue";
import Feedback from "./Feedback.vue";

export default {
  components: { VotesBarchart, ExportSessionButton, Feedback },
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
#public-link-cell {
  display: flex;
  justify-content: space-between;
}
#public-link-cell a {
  margin: auto auto auto 0;
}
#public-link-cell button {
  height: 25px;
}
#data-display-container {
  display: grid;
  gap: 30px;
  grid-template-columns: 1fr 1fr;
}
@media screen and (max-width: 1150px) {
  #data-display-container {
    grid-template-columns: 1fr;
    grid-template-rows: auto;
  }
}
</style>
