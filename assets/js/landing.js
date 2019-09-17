import landingCss from "../css/landing.css"
import portal from "./portal.js"

var logInButton = document.getElementById("log-in")

if (logInButton) {
    logInButton.onclick = function () {
        window.location.href = "/portal"
    }
}