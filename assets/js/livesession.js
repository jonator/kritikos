import livesessionCss from "../css/livesession.css"
import utils from "./utils.js"

const keywordApiPath = "/api/vote/" + keyword

document.getElementById("happy").children[0].onclick = () => {
    utils.fetchData("POST", keywordApiPath + "/1")
}

document.getElementById("surprised").children[0].onclick = () => {
    utils.fetchData("POST", keywordApiPath + "/0")
}

document.getElementById("sad").children[0].onclick = () => {
    utils.fetchData("POST", keywordApiPath + "/-1")
}