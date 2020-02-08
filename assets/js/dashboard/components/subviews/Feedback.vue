<template>
  <div id="feedback-container">
    <h3>Feedback by category</h3>
    <div id="vote-level-tabs">
      <div
        class="vote-level-tab"
        v-for="(v, index) in $store.state.voteLevels"
        :key="v.id"
        :class="{ active: index == currentVoteLevelId -1, clickable: index != currentVoteLevelId -1 }"
        @click="selectVoteLevelTab(v.id)"
      >{{v.voteLevelId}}</div>
    </div>
    <div v-if="feedbacks.length > 0" id="feedbacks-container">
      <p class="feedback" v-for="f in feedbacks" :key="f.id">{{ f.text }}</p>
    </div>
    <p id="no-feedback" v-else>No feedback given for this category</p>
  </div>
</template>

<script>
function mostCommonVoteLevelId(votes) {
  var count = {};
  votes.forEach(v => {
    // indexes might be messed up here (incorrectly counting)
    if (!count[v.voteLevelId]) {
      count[v.voteLevelId] = 1;
    } else {
      count[v.voteLevelId]++;
    }
  });
  const counts = Object.values(count);
  let highestIndex = counts.indexOf(Math.max(...counts));
  return parseInt(Object.keys(counts)[highestIndex]);
}

export default {
  props: ["votes"],
  data: function() {
    return {
      currentVoteLevelId: mostCommonVoteLevelId(this.votes)
    };
  },
  computed: {
    feedbacks: function() {
      const curVotes = this.votes.filter(
        v => v.voteLevelId == this.currentVoteLevelId
      );
      return curVotes.map(v => v.feedback);
    }
  },
  methods: {
    selectVoteLevelTab: function(voteId) {
      this.currentVoteLevelId = voteId;
    }
  },
  mounted: function() {
    this.$nextTick(() => {
      const voteLevels = this.$store.state.voteLevels;
      const htmlTabs = document.getElementsByClassName("vote-level-tab");
      for (var i = 0; i < voteLevels.length; i++) {
        htmlTabs[i].innerHTML = voteLevels[i].svg;
        var innerSVG = htmlTabs[i].children[0];
        innerSVG.setAttribute("height", "40");
        innerSVG.setAttribute("width", "40");
      }
    });
  }
};
</script>

<style scoped>
#feedback-container {
  text-align: center;
}
h3 {
  text-align: left;
}
#feedbacks-container {
  max-height: 450px;
  overflow-y: auto;
  overflow-x: hidden;
}
#vote-level-tabs {
  width: 100%;
  display: inline-flex;
  justify-content: space-evenly;
  margin-bottom: 30px;
}
.vote-level-tab.active {
  border-bottom: 2px solid #eaeaea;
  opacity: 0.6;
}
#no-feedback {
  font-style: italic;
}
</style>
