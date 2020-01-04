<template>
  <div id="sessions-container" class="cards">
    <Session v-for="session in sessions" :key="session.id" :session="session" />
  </div>
</template>

<script>
import Session from "./Session.vue";

export default {
  components: { Session },
  data: function() {
    return {
      sessions: this.$store.state.sessions
    };
  }
};
</script>