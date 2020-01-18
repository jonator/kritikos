<template>
  <div id="create-session-form-container">
    <h3>Create new session</h3>
    <table>
      <col width="180" />
      <col width="10" />
      <tr>
        <td>Name</td>
        <td></td>
        <td>
          <input type="text" placeholder="Database class" v-model="name" />
        </td>
      </tr>
      <tr>
        <td>Keyword</td>
        <td>
          <HelperTooltip
            :position="'left'"
          >This will be used in the url that your audience will use to provide feedback.</HelperTooltip>
        </td>
        <td>
          <input type="text" placeholder="db_class (must be unique and short)" v-model="keyword" />
        </td>
      </tr>
      <tr>
        <td>Prompt question</td>
        <td>
          <HelperTooltip
            :position="'left'"
          >This will be on the initial prompt presented to the users.</HelperTooltip>
        </td>
        <td>
          <input type="text" placeholder="How was your experience?" v-model="promptQuestion" />
        </td>
      </tr>
      <tr>
        <td>Tags</td>
        <td>
          <HelperTooltip
            :position="'left'"
          >These are useful for identifying and categorizing your sessions.</HelperTooltip>
        </td>
        <td>
          <VueTagsInput
            v-model="tag"
            :tags="tags"
            :allow-edit-tags="true"
            :max-length="15"
            @tags-changed="newTags => tags = newTags"
          />
        </td>
      </tr>
    </table>
    <div id="errors-wrapper">
      <div v-for="e in errors" v-bind:key="e.id" class="error">{{e.text}}</div>
    </div>
    <div id="footer-wrapper">
      <button id="cancel-button" @click="dismissModal">cancel</button>
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
    return {
      name: "",
      keyword: "",
      promptQuestion: "",
      tag: "",
      tags: [],
      errors: []
    };
  },
  methods: {
    dismissModal: function() {
      this.$store.dispatch("DISMISS_MODAL");
    },
    confirmCreateSession: function() {
      const newSession = {
        name: this.name,
        keyword: this.keyword,
        promptQuestion: this.promptQuestion,
        tags: this.tags
      };
      this.$store.dispatch("CREATE_SESSION", newSession);
    }
  },
  mounted: function() {
    this.$store.subscribe((mutation, state) => {
      if (mutation.type == "addErrors") {
        this.errors = mutation.payload.map((e, i) => {
          return { id: i, text: e };
        });
      }
    });
  }
};
</script>

<style scoped>
tr td input {
  margin: auto;
}
#footer-wrapper {
  padding-left: 10%;
  padding-right: 10%;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 5%;
}
</style>
