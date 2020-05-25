import livesession_formCss from "../css/livesession_form.css"
import utils from "./utils.js"

document.getElementById("submit-form").onclick = () => {
    const textInput = document.getElementById("input").value
    const url = "/api/" + keyword + "/submit_form"
    const body = {
        text: textInput,
        vote_id: voteId
    }
    utils.apiRequest("POST", url, body).then(toThanks)
}

function toThanks(response) {
    console.log(response)
    if (response["message"] == "SESSION OWNER" || response["feedback"]) {
        window.location = "/" + keyword + "/thanks"
    } else {
        const errors = response.errors.reduce((acc, e) => acc + ", " + e, "")
        alert("There was a problem!\n" + errors);
    }
}