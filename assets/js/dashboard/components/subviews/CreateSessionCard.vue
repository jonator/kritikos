<template>
  <div id="create-session-container">
    <div id="new-session-svg-container">
      <NewSessionSvg id="new-session-svg" />
    </div>
    <button v-on:click="createSession">Start session</button>
  </div>
</template>

<script>
import NewSessionSvg from "../../../../static/svg/dashboard/new_session.svg";

export default {
  components: { NewSessionSvg },
  methods: {
    createSession: function() {
      this.$store.dispatch("OPEN_MODAL", "CreateSessionForm");
    }
  }
};
</script>

<style scoped>
#create-session-container {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
#new-session-svg-container {
  padding: 30px;
}
</style>
