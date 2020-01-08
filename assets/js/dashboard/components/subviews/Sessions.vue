<template>
  <div id="sessions-container" class="cards">
    <Session v-for="session in sessions" :key="session.id" :session="session" />
    <CreateSession />
  </div>
</template>

<script>
import Session from "./Session.vue";
import CreateSession from "./CreateSession.vue";

export default {
  components: { Session, CreateSession },
  data: function() {
    return {
      sessions: this.$store.state.sessions
    };
  }
};
</script>