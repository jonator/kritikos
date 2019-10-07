import livesession_formCss from "../css/livesession_form.css"
import utils from "./utils.js"

document.getElementById("submit-form").onclick = () => {
    const url = "/api/" + keyword + "/submit_form"
    const body = {
        text: document.getElementById("input").value,
        voter_number: voterNumber
    }
    utils.fetchData("POST", url, body).then(r => r.json()).then(r =>
        window.location.href = r.redirect
    )
}