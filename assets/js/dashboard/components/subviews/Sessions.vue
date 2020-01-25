<template>
  <div id="sessions-container">
    <div id="session-cards">
      <div v-if="permanentSession" id="permanent-session-container" class="cards">
        <SessionCard :sessionId="permanentSession.id" />
      </div>
      <h3>
        Open sessions
        <helper-tooltip>Your audience can access sessions that are open through the link. This link provides a simple feedback form that your audience can use to provide anonymous feedback.</helper-tooltip>
      </h3>
      <div id="open-session-container" class="cards">
        <CreateSessionCard />
        <SessionCard v-for="session in openSessions" :key="session.id" :sessionId="session.id" />
      </div>
      <h3>
        Closed sessions
        <helper-tooltip>Closed sessions no longer provide a feedback form at the session link, and only hold feedback data that was collected while it was open.</helper-tooltip>
      </h3>
      <div v-if="closedSessions.length > 0" id="closed-session-container" class="cards">
        <SessionCard v-for="session in closedSessions" :key="session.id" :sessionId="session.id" />
      </div>
      <span v-else>Sessions that are closed will go here, you have none.</span>
    </div>
  </div>
</template>

<script>
import SessionCard from "./SessionCard.vue";
import CreateSessionCard from "./CreateSessionCard.vue";
import HelperTooltip from "../HelperTooltip.vue";

export default {
  name: "Sessions",
  components: { SessionCard, CreateSessionCard, HelperTooltip },
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
