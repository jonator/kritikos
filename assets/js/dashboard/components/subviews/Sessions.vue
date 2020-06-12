<template>
  <div id="sessions-container">
    <TagsFilters />
    <div id="session-cards">
      <h3>
        Open sessions
        <helper-tooltip>Your audience can access sessions that are open through the link. This link provides a simple feedback form that your audience can use to provide anonymous feedback.</helper-tooltip>
      </h3>
      <transition-group tag="div" name="list" id="open-session-container" class="cards">
        <CreateSessionCard v-bind:key="0" />
        <SessionCard
          v-for="session in openSessions"
          v-bind:key="session.id"
          :sessionId="session.id"
        />
      </transition-group>
      <h3>
        Closed sessions
        <helper-tooltip>Closed sessions no longer allow new votes or feedback, and only hold data that was collected while it was open.</helper-tooltip>
      </h3>
      <transition-group
        tag="div"
        name="list"
        v-if="closedSessions.length > 0"
        id="closed-session-container"
        class="cards"
      >
        <SessionCard
          v-for="session in closedSessions"
          v-bind:key="session.id"
          :sessionId="session.id"
        />
      </transition-group>
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
/* #sessions-container {
  height: calc(100vh - 120px - 1px);
} */
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

/* insert animation */
.list-enter-active,
.list-leave-active,
.list-move {
  transition: 500ms cubic-bezier(0.59, 0.12, 0.34, 0.95);
  transition-property: opacity, transform;
}

.list-enter {
  opacity: 0;
  transform: translateX(50px) scaleY(0.5);
}

.list-enter-to {
  opacity: 1;
  transform: translateX(0) scaleY(1);
}

.list-leave-active {
  position: absolute;
}

.list-leave-to {
  opacity: 0;
  transform: scaleY(0);
  transform-origin: center top;
}
.list-item {
  display: inline-block;
  margin-right: 10px;
}
.list-enter-active,
.list-leave-active {
  transition: all 1s;
}
.list-enter, .list-leave-to /* .list-leave-active below version 2.1.8 */ {
  opacity: 0;
  transform: translateY(30px);
}
.list-enter {
  background-color: lightgreen;
}
.list-leave-to {
  background-color: lightsalmon;
}
</style>
