// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import dashboardCss from "../css/dashboard.css"
import * as d3 from "d3"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

var logOutBtn = document.getElementById("log-out")
var createNewSessionBtn = document.getElementById("create-new-session")
var exportOptionsBtn = document.getElementById("export-options")
var openCurrentSessionBtn = document.getElementById("open-current-session")
var viewPreviousSessionsBtn = document.getElementById("view-previous-sessions")
var viewAllSessionsBtn = document.getElementById("view-all-sessions")
var launchSessionBtn = document.getElementById("launch-session")
var closeCurrentSessionBtn = document.getElementById("close-current-session")

logOutBtn.addEventListener("click", () => {
    fetch("/api/users/logout", {
        method: "POST",
        mode: "cors",
        cache: "no-cache",
        credentials: "same-origin",
        headers: {
            "Content-Type": "text/html"
        },
        redirect: "follow",
        referrer: "no-referrer"
    }).then()
}, true)
if (createNewSessionBtn) {
    createNewSessionBtn.onclick = () => { window.location.href = "/dashboard/newSession" }
}
if (exportOptionsBtn) {
    exportOptionsBtn.onclick = () => { window.location.href = "/dashboard/currentSession/export" }
}
if (openCurrentSessionBtn) {
    openCurrentSessionBtn.onclick = () => { window.location.href = "/dashboard/currentSession" }
}
if (viewPreviousSessionsBtn) {
    viewPreviousSessionsBtn.onclick = () => { window.location.href = "/dashboard/previousSessions" }
}
if (viewAllSessionsBtn) {
    viewAllSessionsBtn.onclick = () => { window.location.href = "/dashboard/allSessions" }
}
if (launchSessionBtn) {
    launchSessionBtn.onclick = () => { window.location.href = "/dashboard/currentSession?spawn=true" }
}
if (closeCurrentSessionBtn) {
    closeCurrentSessionBtn.onclick = () => {
        fetch("/api/closeCurrentSession", {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            redirect: "follow",
            referrer: "no-referrer"
        }).then(r => r.json()).then(r => window.location.href = r.redirect)
    }
}

// prev-session

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