import exportCss from "../css/export.css"
import utils from "./utils.js"

var fullscreenBtn = document.getElementById("open-fullscreen")
var pngDownloadBtn = document.getElementById("png-download-start")
var pdfDownloadBtn = document.getElementById("pdf-download-start")

if (fullscreenBtn) {
    fullscreenBtn.onclick = () => { window.location.href = "/dashboard/currentSession/export/fullscreen" }
}

if (pngDownloadBtn) {
    pngDownloadBtn.onclick = () => {
        const url = "/export/qrcode/" + keyword + ".png"
        utils.download(url)
    }
}

if (pdfDownloadBtn) {
    pdfDownloadBtn.onclick = () => {

    }
}