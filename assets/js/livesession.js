import livesessionCss from "../css/livesession.css"
import utils from "./utils.js"

const keywordApiPath = "/api/vote/" + keyword
const formRequestPath = "/" + keyword + "/form"

document.getElementById("happy").children[0].onclick = () => {
    utils.apiRequest("POST", keywordApiPath + "/3").then(toForm)
}

document.getElementById("neutral").children[0].onclick = () => {
    utils.apiRequest("POST", keywordApiPath + "/2").then(toForm)
}

document.getElementById("frown").children[0].onclick = () => {
    utils.apiRequest("POST", keywordApiPath + "/1").then(toForm)
}

function toForm(response) {
    console.log(response)
    if (!isKiosk) {
        const vote = response.vote
        const formReqQueryParams = {
            voteLevelId: vote.voteLevelId,
            voteId: vote.id
        }
        window.location = formRequestPath + "?" + utils.serializeQueryParams(formReqQueryParams)
    }
}
