// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import dashboardCss from "../css/dashboard.css"


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