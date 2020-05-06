<template>
  <div id="sessions-container">
    <TagsFilters />
    <div id="session-cards">
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
        <helper-tooltip>Closed sessions no longer provide a feedback form at the session link, and only hold data that was collected while it was open.</helper-tooltip>
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
import VueTagsInput from "@johmun/vue-tags-input";
import TagsFilters from "./TagsFilters.vue";

export default {
  components: {
    SessionCard,
    CreateSessionCard,
    HelperTooltip,
    TagsFilters
  },
  computed: {
    openSessions: function() {
      return this.$store.getters.filteredSessions.filter(s => !s.isEnded);
    },
    closedSessions: function() {
      return this.$store.getters.filteredSessions.filter(s => s.isEnded);
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
#session-cards {
  padding-bottom: 300px;
}

/* chevron-down */
.gg-chevron-down {
  box-sizing: border-box;
  position: relative;
  display: block;
  transform: scale(var(--ggs, 1));
  width: 22px;
  height: 22px;
  border: 2px solid transparent;
  border-radius: 100px;
}
.gg-chevron-down::after {
  content: "";
  display: block;
  box-sizing: border-box;
  position: absolute;
  width: 10px;
  height: 10px;
  border-bottom: 2px solid;
  border-right: 2px solid;
  transform: rotate(45deg);
  left: 4px;
  top: 2px;
}

/* chevron-up */
.gg-chevron-up {
  box-sizing: border-box;
  position: relative;
  display: block;
  transform: scale(var(--ggs, 1));
  width: 22px;
  height: 22px;
  border: 2px solid transparent;
  border-radius: 100px;
}
.gg-chevron-up::after {
  content: "";
  display: block;
  box-sizing: border-box;
  position: absolute;
  width: 10px;
  height: 10px;
  border-top: 2px solid;
  border-right: 2px solid;
  transform: rotate(-45deg);
  left: 4px;
  bottom: 2px;
}
</style>
