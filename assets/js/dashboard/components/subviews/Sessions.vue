<template>
  <div id="sessions-container">
    <div id="session-cards">
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
  </div>
</template>

<script>
import SessionCard from "./SessionCard.vue";
import CreateSessionCard from "./CreateSessionCard.vue";

export default {
  name: "Sessions",
  components: { SessionCard, CreateSessionCard },
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
