<template>
  <div id="feedback-container">
    <h3>Feedback by category</h3>
    <div id="vote-level-tabs">
      <div
        class="vote-level-tab"
        v-for="(v, index) in $store.state.voteLevels"
        :key="index"
        :class="{ active: v.id == currentVoteLevelId, clickable: v.id != currentVoteLevelId }"
        @click="selectVoteLevelTab(v.id)"
      >{{v.voteLevelId}}</div>
    </div>
    <div id="feedbacks-container">
      <table v-if="feedbacks.length > 0">
        <col width="70%" />
        <col width="30%" />
        <tr class="feedback" v-for="f in feedbacks" :key="f.id">
          <td
            v-if="f.type == 'bucket'"
            id="feedback-time-bucket"
            colspan="2"
          >{{ f.dateBucketMonthDay }}</td>
          <td v-if="f.type == 'feedback'" id="feedback-text">{{ f.text }}</td>
          <td v-if="f.type == 'feedback'" id="feedback-time">{{ f.voteDatetime }}</td>
        </tr>
      </table>
      <p v-else id="no-feedback">No feedback given for this category</p>
    </div>
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
      const dateBucketsDict = this.votes
        .filter(v => v.voteLevelId == this.currentVoteLevelId)
        .sort((a, b) => b.voteDatetime - a.voteDatetime)
        .reduce((acc, v) => {
          if (v.feedback != undefined) {
            const feedbackMoment = moment(v.voteDatetime);
            const monthAndDay = feedbackMoment.format("MMM Do");
            if (!acc[monthAndDay]) {
              acc[monthAndDay] = [];
            }
            acc[monthAndDay].push({
              type: "feedback",
              ...v.feedback,
              voteDatetime: feedbackMoment.format("hh:mm a")
            });
            return acc;
          } else {
            return acc;
          }
        }, {});

      return Object.keys(dateBucketsDict).reduce((acc, dateBucket) => {
        acc.push({ type: "bucket", dateBucketMonthDay: dateBucket });
        return acc.concat(dateBucketsDict[dateBucket]);
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
  height: 450px;
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
#feedback-time-bucket {
  font-size: 70%;
  font-weight: bold;
  border-bottom: 1px solid #eaeaea;
  padding-bottom: 0.5rem;
}
#feedback-text {
  word-wrap: break-word;
  max-width: 350px;
  user-select: text;
}
#feedback-time {
  vertical-align: top;
  text-align: end;
  font-size: 70%;
}
</style>
