<template>
  <div id="filters-container">
    <button @click="showFilters = !showFilters" id="filters-button">
      <span>Filters</span>
      <i v-if="showFilters" class="gg-chevron-up" />
      <i v-else class="gg-chevron-down" />
    </button>
    <div v-if="showFilters" id="filters-wrapper">
      <div id="filter-tags">
        <div id="filter-label">
          <span>Include tags on session</span>
        </div>
        <VueTagsInput
          v-model="filterTag"
          :tags="$store.state.sessionsFilters.filterTags"
          :allow-edit-tags="true"
          :maxlength="15"
          :add-on-key="[13, ' ']"
          :autocomplete-items="tagsAutoComplete"
          :add-only-from-autocomplete="true"
          @tags-changed="tagsChanged"
        />
      </div>
    </div>
  </div>
</template>

<script>
import VueTagsInput from "@johmun/vue-tags-input";

export default {
  components: { VueTagsInput },
  data: function() {
    return { showFilters: false, filterTag: "" };
  },
  computed: {
    tagsAutoComplete: function() {
      const sessions = this.$store.state.sessions;
      return Array.from(
        sessions.reduce((set, session) => {
          session.tags.forEach(tag => set.add(tag.text));
          return set;
        }, new Set())
      ).map((tag, i) => {
        return { id: i, text: tag };
      });
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
#filters-button {
  display: inline-flex;
  background-color: transparent;
  color: black;
}
#filters-button i {
  margin: auto;
  margin-left: 5px;
}
#filters-button:hover {
  background-color: lightblue;
}
#filters-container {
  margin-bottom: 30px;
}
#filters-wrapper {
  max-width: 600px;
  padding: 30px;
}
#filter-tags {
  display: grid;
  grid-template-columns: 1fr 3fr;
}
#filter-tags span {
  margin: auto;
}
</style>
