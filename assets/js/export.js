import exportCss from "../css/export.css"

var fullscreenBtn = document.getElementById("open-fullscreen")
var pngDownloadBtn = document.getElementById("png-download-start")
var pdfDownloadBtn = document.getElementById("pdf-download-start")

if (fullscreenBtn) {
    fullscreenBtn.onclick = () => { window.location.href = "/dashboard/currentSession/export/fullscreen" }
}

if (pngDownloadBtn) {
    pngDownloadBtn.onclick = () => {

    }
}