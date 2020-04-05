<template>
  <div id="session-container">
    <div id="actions">
      <button v-on:click="$router.push('/sessions')">back</button>
    </div>
    <table>
      <col width="200" />
      <tr>
        <td>
          <h2>{{ session.keyword }}</h2>
        </td>
        <td />
      </tr>
      <tr>
        <td>
          <div id="url-wrapper">
            Public URL
            <HelperTooltip>This link is used by your audience to provide feedback through a simple web applet. Click to preview. Your input will not affect feedback data.</HelperTooltip>
          </div>
        </td>
        <td id="public-link-cell">
          <a v-bind:href="session.link">{{ session.link }}</a>
          <div id="session-actions" v-if="!sessionIsEnded">
            <button class="warning" v-on:click="endSession">close</button>
            <button
              v-on:click="$store.dispatch('OPEN_MODAL', {form: 'ExportSession', initialState: {keyword: session.keyword}})"
            >export</button>
          </div>
        </td>
      </tr>
      <tr>
        <td>Vote count</td>
        <td>{{ session.votes.length }}</td>
      </tr>
      <tr v-if="session.promptQuestion != null">
        <td>Custom prompt question</td>
        <td>{{ session.promptQuestion }}</td>
      </tr>
      <tr>
        <td>Start date/time</td>
        <td>{{ session.startMoment.format("LLLL") }} ({{ session.startMoment.fromNow() }})</td>
      </tr>
      <tr v-if="sessionIsEnded">
        <td>End date/time</td>
        <td>{{ session.endMoment.format("LLLL") }} ({{ session.endMoment.fromNow() }})</td>
      </tr>
      <tr>
        <td>Tags</td>
        <td id="tags-list">
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
import HelperTooltip from "../HelperTooltip.vue";
import VotesBarchart from "../charts/VotesBarchart.vue";
import Feedback from "./Feedback.vue";
import moment from "moment";

export default {
  components: { HelperTooltip, VotesBarchart, Feedback },
  computed: {
    session: function() {
      var s = this.$store.state.sessions.find(s => {
        return s.keyword == this.$route.params.keyword;
      });
      s.startMoment = moment(s.startDatetime);
      s.endMoment = moment(s.endDatetime);
      return s;
    },
    sessionIsEnded: function() {
      return (
        this.session.endDatetime != null ||
        this.session.endDatetime != undefined
      );
    }
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
#url-wrapper {
  display: flex;
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
#tags-list {
  display: flex;
}
#tags-list div {
  padding-right: 5px;
}
</style>
