<template>
  <div id="votes-barchart-container">
    <h3>Votes</h3>
    <svg v-if="votes.length > 0 && !isMobile" width="400" height="400" id="bar-chart" />
    <svg v-else-if="votes.length > 0 && isMobile" width="325" height="325" id="bar-chart" />
    <p v-else>No votes to display</p>
  </div>
</template>

<script>
import * as d3 from "d3";

export default {
  props: ["votes"],
  data: function () {
    return {
      votesProcessed: this.votes,
    };
  },
  computed: {
    isMobile: function () {
      return this.$store.getters.isMobile;
    },
  },
  methods: {
    renderBarChart: function (votes) {
      if (votes.length == 0 || !votes) return;
      d3.select("#bar-chart").selectAll("*").remove();

      const data = votes.reduce((acc, v) => {
        // creates an object with vote levels as keys and count as members
        if (acc[v.voteLevelId] == undefined) {
          acc[v.voteLevelId] = 1;
        } else {
          acc[v.voteLevelId]++;
        }
        return acc;
      }, {});

      const voteCounts = Object.values(data).reverse();
      const voteLevelKeys = Object.keys(data).reverse();

      var svg = d3.select("#bar-chart"),
        margin = {
          top: 20,
          right: 20,
          bottom: 50,
          left: 50,
        },
        voteIconSize = 40,
        width = +svg.attr("width") - margin.left - margin.right,
        height = +svg.attr("height") - margin.top - margin.bottom,
        g = svg
          .append("g")
          .attr(
            "transform",
            "translate(" + margin.left + "," + margin.top + ")"
          );

      var x = d3.scaleBand().rangeRound([0, width]).padding(0.1);

      var y = d3.scaleLinear().rangeRound([height, 0]);

      x.domain(
        voteLevelKeys.map(function (d) {
          return d;
        })
      );

      y.domain([
        0,
        d3.max(voteCounts, function (d) {
          return d;
        }),
      ]);

      g.append("g")
        .call(d3.axisLeft(y).ticks(Math.log(Math.max(...voteCounts)) * 2))
        .append("text")
        .attr("fill", "#000")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", "0.71em")
        .attr("text-anchor", "end");

      g.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x).tickValues([]));

      var bar = g
        .selectAll(".bar")
        .data(voteLevelKeys)
        .enter()
        .append("rect")
        .attr("class", "bar")
        .attr("x", function (d) {
          return x(d);
        })
        .attr("y", function (d) {
          return y(data[d]);
        })
        .attr("width", x.bandwidth())
        .attr("height", function (d) {
          return height - y(data[d]);
        })
        .style("fill", "#d1d1d1");

      g.selectAll(".voteIcon")
        .data(voteLevelKeys)
        .enter()
        .append("g")
        .html(function (d) {
          //done because icon is determined server side
          const voteId = parseInt(d);
          var newSVG = document.createElement("svg");
          newSVG.innerHTML = voteLevels.find((l) => l.id == voteId).svg;
          var innerSVG = newSVG.children[0];
          innerSVG.setAttribute("height", voteIconSize);
          innerSVG.setAttribute("width", voteIconSize);
          innerSVG.setAttribute(
            "x",
            x(d) + x.bandwidth() / 2 - voteIconSize / 2
          );
          innerSVG.setAttribute("y", height + 5);
          return newSVG.innerHTML;
        });

      const voteCountFontsize = 18;

      g.selectAll(".voteCount")
        .data(voteLevelKeys)
        .enter()
        .append("text")
        .attr("x", (d) => {
          const digitCount = data[d].toString().length;
          return (
            x(d) + x.bandwidth() / 2 - (voteCountFontsize / 4) * digitCount
          );
        })
        .attr("y", height - 15)
        .attr("font-size", voteCountFontsize)
        .text((d) => data[d]);
    },
  },
  updated: function () {
    this.renderBarChart(this.votes);
  },
  mounted: function () {
    this.renderBarChart(this.votes);
  },
};
</script>

<style scoped>
#votes-barchart-container p {
  font-style: italic;
}
</style>
