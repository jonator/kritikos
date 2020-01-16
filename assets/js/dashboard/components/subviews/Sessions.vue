<template>
  <div id="sessions-container">
    <div v-if="$store.state.selectedSessionId == null" id="session-cards" class="cards">
      <CreateSession />
      <SessionCard v-for="session in $store.state.sessions" :key="session.id" :session="session" />
    </div>
    <div v-else id="open-session-container">
      <button id="sessions-back" v-on:click="$store.dispatch('DESELECT_SESSION')">🔙</button>
      <Session :session="$store.getters.selectedSession" />
    </div>
  </div>
</template>

<script>
import SessionCard from "./SessionCard.vue";
import Session from "./Session.vue";
import CreateSession from "./CreateSession.vue";

export default {
  components: { Session, SessionCard, CreateSession }
};
</script>

<style scoped>
#session-cards {
  padding-bottom: 30px;
}
</style>
