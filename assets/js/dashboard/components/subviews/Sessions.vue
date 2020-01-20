<template>
  <div id="sessions-container">
    <div v-if="$store.getters.selectedSession == null" id="session-cards">
      <div v-if="permanentSession" id="permanent-session-container" class="cards">
        <SessionCard :sessionId="permanentSession.id" />
      </div>
      <h3>Open sessions</h3>
      <div id="open-session-container" class="cards">
        <CreateSessionCard />
        <SessionCard v-for="session in openSessions" :key="session.id" :sessionId="session.id" />
      </div>
      <h3>Closed sessions</h3>
      <div id="closed-session-container" class="cards">
        <SessionCard v-for="session in closedSessions" :key="session.id" :sessionId="session.id" />
      </div>
    </div>
    <div v-else id="selected-session-container">
      <button id="sessions-back" v-on:click="$store.dispatch('DESELECT_SESSION')">back</button>
      <Session :sessionId="$store.getters.selectedSession.id" />
    </div>
  </div>
</template>

<script>
import SessionCard from "./SessionCard.vue";
import Session from "./Session.vue";
import CreateSessionCard from "./CreateSessionCard.vue";

export default {
  components: { Session, SessionCard, CreateSessionCard },
  computed: {
    permanentSession: function() {
      return this.$store.state.sessions.find(s => s.isPermanent);
    },
    openSessions: function() {
      return this.$store.state.sessions.filter(
        s => !s.isEnded && !s.isPermanent
      );
    },
    closedSessions: function() {
      return this.$store.state.sessions.filter(
        s => s.isEnded && !s.isPermanent
      );
    }
  }
};
</script>

<style scoped>
#sessions-container {
  overflow-y: auto;
  height: calc(100vh - 120px - 1px);
}
.cards {
  padding-bottom: 30px;
}
</style>
