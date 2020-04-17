import livesession_formCss from "../css/livesession_form.css"
import utils from "./utils.js"

document.getElementById("submit-form").onclick = () => {
    const textInput = document.getElementById("input").value
    const url = "/api/" + keyword + "/submit_form"
    const body = {
        text: textInput,
        vote_id: voteId
    }
    utils.apiRequest("POST", url, body).then(r => {
        window.location.href = r.redirect
    })
}