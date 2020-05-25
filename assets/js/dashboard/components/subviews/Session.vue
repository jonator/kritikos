<template>
  <div id="session-container">
    <div id="actions">
      <button v-on:click="$router.go(-1)">back</button>
    </div>
    <h2>Results for {{ session.name }}</h2>
    <div v-if="sessionIsEnded" id="closed-session-actions">
      <button id="delete-session" class="warning" @click="deleteSession">delete session</button>
    </div>
    <table>
      <col width="200" />
      <tr>
        <td>
          <div id="url-wrapper">
            Public URL
            <HelperTooltip>This link is used by your audience to provide feedback through a simple web applet. Click to preview. Your input will not affect feedback data.</HelperTooltip>
          </div>
        </td>
        <td id="public-link-cell">
          <a v-bind:href="session.link" target="_blank">{{ session.link }}</a>
          <div id="session-actions" v-if="!sessionIsEnded">
            <button class="warning" v-on:click="endSession">close</button>
            <button
              v-on:click="$store.dispatch('OPEN_MODAL', {form: 'ExportSession', initialState: {keyword: session.keyword}})"
            >export</button>
          </div>
        </td>
      </tr>
      <transition name="slide-fade">
        <tr v-if="infoDrawerOpen">
          <td>Vote count</td>
          <td>{{ session.votes.length }}</td>
        </tr>
      </transition>
      <transition name="slide-fade">
        <tr v-if="session.promptQuestion != null && infoDrawerOpen">
          <td>Custom prompt question</td>
          <td>{{ session.promptQuestion }}</td>
        </tr>
      </transition>
      <transition name="slide-fade">
        <tr v-if="infoDrawerOpen">
          <td>Start date/time</td>
          <td>{{ session.startMoment.format("LLLL") }} ({{ session.startMoment.fromNow() }})</td>
        </tr>
      </transition>
      <transition name="slide-fade">
        <tr v-if="sessionIsEnded && infoDrawerOpen">
          <td>End date/time</td>
          <td>{{ session.endMoment.format("LLLL") }} ({{ session.endMoment.fromNow() }})</td>
        </tr>
      </transition>
      <transition name="slide-fade">
        <tr v-if="infoDrawerOpen">
          <td>Tags</td>
          <td id="tags-list">
            <div v-for="tag in session.tags" :key="tag.id">{{ tag.text }}</div>
          </td>
        </tr>
      </transition>
      <tr>
        <td>
          <a v-on:click="toggleInfoDrawer">{{ infoDrawerOpen ? "Less" : "More" }} info</a>
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
        this.session.endDatetime != null &&
        this.session.endDatetime != undefined
      );
    },
    infoDrawerOpen: function() {
      return this.$store.state.sessionInfoDrawerOpen;
    }
  },
  methods: {
    endSession: function() {
      this.$store.dispatch("END_SESSION", this.session.keyword);
    },
    toggleInfoDrawer: function() {
      this.$store.dispatch("TOGGLE_SESSION_INFO_DRAWER");
    },
    deleteSession: function() {
      this.$store.dispatch("DELETE_SESSION", this.session.id).then(() => {
        this.$router.replace({ path: "/sessions" });
      });
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
.mobile #session-container {
  padding-top: 10px;
}
#url-wrapper {
  display: flex;
}
#actions {
  padding-bottom: 30px;
}
#session-actions {
  display: inline-flex;
  justify-content: flex-end;
}
#session-actions button {
  margin-left: 10px;
}
.mobile #session-actions {
  padding-top: 5px;
}
.mobile #session-actions button {
  margin-left: 0;
  margin-right: 5px;
}
#public-link-cell {
  display: flex;
  justify-content: space-between;
}
.mobile #public-link-cell {
  display: block;
  padding: 10px;
}
#public-link-cell a {
  margin: auto auto auto 0;
}
#public-link-cell button {
  margin-bottom: 0;
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

/* info transition */
.slide-fade-enter-active {
  transition: all 0.3s ease;
}
.slide-fade-leave-active {
  transition: all 0.3s cubic-bezier(1, 0.5, 0.8, 1);
}
.slide-fade-enter, .slide-fade-leave-to
/* .slide-fade-leave-active below version 2.1.8 */ {
  transform: translateY(-10px);
  opacity: 0;
}
</style>
