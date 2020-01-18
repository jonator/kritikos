<template>
  <div id="sessions-container">
    <div v-if="$store.getters.selectedSession == null" id="session-cards" class="cards">
      <CreateSessionCard />
      <SessionCard v-for="session in sessions" :key="session.id" :sessionId="session.id" />
    </div>
    <div v-else id="open-session-container">
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
    sessions: function() {
      return this.$store.state.sessions;
    }
  }
};
</script>

<style scoped>
#session-cards {
  padding-bottom: 30px;
}
</style>
