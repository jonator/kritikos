<template>
  <div id="sessions-container">
    <div id="filters-container">
      <button @click="showFilters = !showFilters" id="filters-button">
        <span>Filters</span>
        <i v-if="showFilters" class="gg-chevron-up" />
        <i v-else class="gg-chevron-down" />
      </button>
      <div v-if="showFilters" id="filters-wrapper">
        <div id="filter-tags">
          <span>Include tags</span>
          <VueTagsInput
            v-model="filterTag"
            :tags="$store.state.sessionsFilters.filterTags"
            :allow-edit-tags="true"
            :maxlength="15"
            :add-on-key="[13, ' ']"
            @tags-changed="tagsChanged"
          />
        </div>
      </div>
    </div>
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

export default {
  components: { SessionCard, CreateSessionCard, HelperTooltip, VueTagsInput },
  data: function() {
    return {
      showFilters: false,
      filterTag: ""
    };
  },
  computed: {
    filteredSessions: function() {
      var sessions = this.$store.state.sessions;
      const filterTagsText = this.$store.state.sessionsFilters.filterTags.map(
        ft => ft.text
      );
      if (filterTagsText.length == 0) return sessions;
      return sessions.filter(s => {
        const sessionTagsText = s.tags.map(st => st.text);
        var hasAtLeastOneTag = false;
        sessionTagsText.forEach(stt => {
          if (filterTagsText.includes(stt)) {
            hasAtLeastOneTag = true;
          }
        });
        return hasAtLeastOneTag;
      });
    },
    openSessions: function() {
      return this.filteredSessions.filter(s => !s.isEnded);
    },
    closedSessions: function() {
      return this.filteredSessions.filter(s => s.isEnded);
    }
  },
  methods: {
    tagsChanged: function(newTags) {
      this.$store.dispatch("UPDATE_SESSIONS_FILTER", { filterTags: newTags });
    }
  }
};
</script>

<style scoped>
#sessions-container {
  overflow-y: auto;
  height: calc(100vh - 120px - 1px);
}
#filters-container {
  margin-bottom: 30px;
}
#filters-wrapper {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  padding: 30px;
}
#filter-tags {
  display: grid;
  grid-template-columns: 1fr 3fr;
}
#filter-tags span {
  margin: auto;
}
.cards {
  padding-bottom: 30px;
}
#filters-button {
  display: inline-flex;
  background-color: transparent;
  color: black;
}
#filters-button:hover {
  background-color: lightblue;
}
#filters-button i {
  margin: auto;
  margin-left: 5px;
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
