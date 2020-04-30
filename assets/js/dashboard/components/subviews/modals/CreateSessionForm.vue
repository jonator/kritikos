<template>
  <div id="create-session-form-container">
    <h3>Create new session</h3>
    <table>
      <col width="180" />
      <col width="10" />
      <tr>
        <td>Session Name</td>
        <td>
          <HelperTooltip>Only visible to you.</HelperTooltip>
        </td>
        <td>
          <input type="text" placeholder="i.e. Dining room" v-model="name" />
        </td>
      </tr>
      <tr>
        <td>Keyword</td>
        <td>
          <HelperTooltip>Will be in the URL that your audience will use to provide feedback. It must be unique and short, with only letters, numbers, and underscores/hyphens.</HelperTooltip>
        </td>
        <td>
          <input type="text" placeholder="i.e. dining_room2020" v-model="keyword" />
        </td>
      </tr>
      <tr>
        <td>Prompt question</td>
        <td>
          <HelperTooltip>Will be the initial prompt presented to the users. Must not exceed 50 characters.</HelperTooltip>
        </td>
        <td>
          <input type="text" placeholder="How was your experience?" v-model="promptQuestion" />
        </td>
      </tr>
      <tr>
        <td>Tags</td>
        <td>
          <HelperTooltip>Can be used for identifying and categorizing your sessions. Tags are optional. (Max 10)</HelperTooltip>
        </td>
        <td>
          <VueTagsInput
            v-model="tag"
            :tags="tags"
            :allow-edit-tags="true"
            :maxlength="15"
            :add-on-key="[13,' ']"
            :max-tags="10"
            :placeholder="'Type tag and press enter'"
            @tags-changed="newTags => tags = newTags"
          />
        </td>
      </tr>
    </table>
    <div id="footer-wrapper">
      <button id="cancel-button" @click="$emit('dismiss')">cancel</button>
      <button
        id="create-session-button"
        class="confirm"
        @click="confirmCreateSession"
      >create session</button>
    </div>
  </div>
</template>

<script>
import VueTagsInput from "@johmun/vue-tags-input";
import HelperTooltip from "../../HelperTooltip.vue";

export default {
  name: "CreateSessionForm",
  components: { VueTagsInput, HelperTooltip },
  data: function() {
    return this.$store.state.modalState;
  },
  methods: {
    confirmCreateSession: function() {
      const newSession = {
        name: this.name,
        keyword: this.keyword,
        promptQuestion: this.promptQuestion,
        tags: this.tags
      };
      if (this.$store.getters.filtersAreSet) {
        if (confirm("Are you sure? Creating a session will clear filters")) {
          this.$store.dispatch("CREATE_SESSION", newSession);
        }
      } else {
        this.$store.dispatch("CREATE_SESSION", newSession);
      }
    }
  }
};
</script>

<style scoped>
tr td input {
  margin: auto;
}
#errors-wrapper {
  padding-bottom: 20px;
}
#footer-wrapper {
  padding-left: 10%;
  padding-right: 10%;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 5%;
}
</style>
