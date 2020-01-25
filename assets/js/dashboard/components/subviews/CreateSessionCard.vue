<template>
  <div id="create-session-container">
    <div id="new-session-svg-container">
      <NewSessionSvg id="new-session-svg" />
    </div>
    <div id="footer-wrapper">
      <HelperTooltip
        :vPosition="'top'"
      >A session is a time-centric way to organize your feedback. They are each associated with a URL that your target audience can use to access a feedback form. Once closed the session can no longer be accessed.</HelperTooltip>
      <button id="start-session-button" v-on:click="createSession">Start session</button>
    </div>
  </div>
</template>

<script>
import NewSessionSvg from "../../../../static/svg/dashboard/new_session.svg";
import HelperTooltip from "../HelperTooltip.vue";

export default {
  components: { NewSessionSvg, HelperTooltip },
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
  /* padding: 20px; */
  margin: auto;
}
#new-session-svg-container > * {
  height: 100%;
  width: 90%;
}
#footer-wrapper {
  display: grid;
  grid-template-columns: 50px 1fr;
}
#start-session-button {
  margin: 0;
}
</style>
