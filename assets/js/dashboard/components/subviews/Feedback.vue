<template>
  <div id="feedback-container">
    <h3>Feedback by category</h3>
    <div id="vote-level-tabs">
      <div
        class="vote-level-tab"
        v-for="(v, index) in $store.state.voteLevels"
        :key="index"
        :class="{ active: index == currentVoteLevelId - 1, clickable: index != currentVoteLevelId - 1 }"
        @click="selectVoteLevelTab(v.id)"
      >{{v.voteLevelId}}</div>
    </div>
    <div v-if="feedbacks.length > 0" id="feedbacks-container">
      <table>
        <col width="70%" />
        <col width="30%" />
        <tr class="feedback" v-for="f in feedbacks" :key="f.id">
          <td id="feedback-text">{{ f.text }}</td>
          <td id="feedback-time">{{ f.voteDatetime.format("lll") }}</td>
        </tr>
      </table>
    </div>
    <p id="no-feedback" v-else>No feedback given for this category</p>
  </div>
</template>

<script>
import moment from "moment";

function mostCommonVoteLevelId(voteLevels, votes) {
  var count = {};
  voteLevels.forEach(vl => {
    count[vl.id] = 0;
  });
  votes.forEach(v => {
    if (v.feedback != undefined || v.feedback) count[v.voteLevelId]++;
  });
  const counts = Object.values(count);
  let highestIndex = counts.indexOf(Math.max(...counts));
  if (highestIndex == -1) return 1;
  return parseInt(Object.keys(counts)[highestIndex]) + 1;
}

export default {
  props: ["votes"],
  data: function() {
    return {
      currentVoteLevelId: mostCommonVoteLevelId(
        this.$store.state.voteLevels,
        this.votes
      )
    };
  },
  watch: {
    votes: {
      handler: function() {
        this.renderSmileys();
        this.currentVoteLevelId = mostCommonVoteLevelId(
          this.$store.state.voteLevels,
          this.votes
        );
      },
      deep: true
    }
  },
  computed: {
    feedbacks: function() {
      const curVotes = this.votes.filter(
        v => v.voteLevelId == this.currentVoteLevelId
      );
      return curVotes.reduce((acc, v) => {
        if (v.feedback != undefined) {
          return acc.concat({
            ...v.feedback,
            voteDatetime: moment(v.voteDatetime)
          });
        } else {
          return acc;
        }
      }, []);
    }
  },
  methods: {
    renderSmileys: function() {
      const voteLevels = this.$store.state.voteLevels;
      const htmlTabs = document.getElementsByClassName("vote-level-tab");
      for (var i = 0; i < voteLevels.length; i++) {
        htmlTabs[i].innerHTML = voteLevels[i].svg;
        var innerSVG = htmlTabs[i].children[0];
        innerSVG.setAttribute("height", "40");
        innerSVG.setAttribute("width", "40");
      }
    },
    selectVoteLevelTab: function(voteLevelId) {
      this.currentVoteLevelId = voteLevelId;
    }
  },
  mounted: function() {
    this.$nextTick(() => this.renderSmileys());
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
  overflow-y: scroll;
  overflow-x: hidden;
}
#vote-level-tabs {
  width: 100%;
  display: inline-flex;
  justify-content: space-evenly;
}
.vote-level-tab {
  opacity: 0.4;
}
.vote-level-tab.active {
  opacity: 1;
}
#no-feedback {
  font-style: italic;
}
#feedback-text {
  max-width: 100%;
}
#feedback-time {
  text-align: end;
  font-size: 70%;
}
</style>
