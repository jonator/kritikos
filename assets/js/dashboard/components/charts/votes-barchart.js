import * as d3 from "d3"

var barChart = document.getElementById("bar-chart")

function tallyVoteData() {
    var output = {}
    for (var i = 0; i < voteData.length; i++) {
        const cur = voteData[i]
        if (output[cur.vote_level_id] == undefined) {
            output[cur.vote_level_id] = 1
        } else {
            output[cur.vote_level_id]++
        }
    }
    return output
}

if (barChart) {
    var data = tallyVoteData()

    console.log(data)

    var svg = d3.select("#bar-chart"),
        margin = {
            top: 20,
            right: 20,
            bottom: 50,
            left: 50
        },
        voteIconSize = 40,
        width = +svg.attr("width") - margin.left - margin.right,
        height = +svg.attr("height") - margin.top - margin.bottom,
        g = svg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")")

    var x = d3.scaleBand()
        .rangeRound([0, width])
        .padding(0.1)

    var y = d3.scaleLinear()
        .rangeRound([height, 0])

    x.domain(Object.keys(data).map(function (d) {
        return d
    }))

    y.domain([0, d3.max(Object.values(data), function (d) {
        return d
    })])

    g.append("g")
        .attr("transform", "translate(0," + height + ")")
        .call(d3.axisBottom(x).tickValues([]))

    g.append("g")
        .call(d3.axisLeft(y).ticks(Math.max(...Object.values(data))))
        .append("text")
        .attr("fill", "#000")
        .attr("transform", "rotate(-90)")
        .attr("y", 6)
        .attr("dy", "0.71em")
        .attr("text-anchor", "end")
        .text("Count")

    var bar = g.selectAll(".bar")
        .data(Object.keys(data))
        .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function (d) {
            return x(d)
        })
        .attr("y", function (d) {
            return y(data[d])
        })
        .attr("width", x.bandwidth())
        .attr("height", function (d) {
            return height - y(data[d])
        })

    g.selectAll(".voteIcon")
        .data(Object.keys(data))
        .enter().append("g")
        .html(function (d) {
            //done because icon is determined server side
            var newSVG = document.createElement("svg")
            newSVG.innerHTML = voteLevelsToSvg[d]
            var innerSVG = newSVG.children[0]
            innerSVG.setAttribute("height", voteIconSize)
            innerSVG.setAttribute("width", voteIconSize)
            innerSVG.setAttribute("x", x(d) + (x.bandwidth() / 2) - voteIconSize / 2)
            innerSVG.setAttribute("y", height + 5)
            return newSVG.innerHTML
        })
}