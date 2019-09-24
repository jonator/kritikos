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

document.getElementById("log-out").addEventListener("click", () => {
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
    })
}, true)

if (document.getElementById("create-new-session")) {
    document.getElementById("create-new-session").onclick = () => { window.location.href = "/dashboard/newSession" }
}
if (document.getElementById("view-previous-sessions")) {
    document.getElementById("view-previous-sessions").onclick = () => { window.location.href = "/dashboard/previousSessions" }
}
if (document.getElementById("view-all-sessions")) {
    document.getElementById("view-all-sessions").onclick = () => { window.location.href = "/dashboard/allSessions" }
}

if (document.getElementById("launch-session")) {
    document.getElementById("launch-session").onclick = () => { window.location.href = "/" }
}