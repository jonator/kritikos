import livesession_formCss from "../css/livesession_form.css"
import utils from "./utils.js"

document.getElementById("submit-form").onclick = () => {
    const url = "/api/" + keyword + "/submit_form"
    const body = {
        vote_level: voteLevel,
        input: document.getElementById("input").value
    }
    utils.fetchData("POST", url, body).then()
}