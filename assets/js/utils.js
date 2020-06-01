module.exports = {
    apiRequest: function (method, url = '', data = {}) {
        // Default options are marked with *

        return fetch(url, {
            method: method, // *GET, POST, PUT, DELETE, etc.
            mode: 'cors', // no-cors, *cors, same-origin
            cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
            credentials: 'same-origin', // include, *same-origin, omit
            headers: {
                'Content-Type': 'application/json'
            },
            redirect: 'follow', // manual, *follow, error
            referrer: 'no-referrer', // no-referrer, *client
            body: (method.toUpperCase() == "GET" || method.toUpperCase() == "HEAD") ? null : JSON.stringify(data), // body data type must match "Content-Type" header
        }).then(resp => resp.json())
    },
    isMobile: function () {
        return window.innerWidth < 680;
    },
    download: function (dataurl) {
        var a = document.createElement("a");
        a.href = dataurl;
        a.click();
        a.remove();
    },
    copyToClipboard: function (string) {
        const el = document.createElement('textarea');
        el.value = string;
        document.body.appendChild(el);
        el.select();
        document.execCommand('copy');
        document.body.removeChild(el);
    },
    serializeQueryParams: function (obj) {
        var str = [];
        for (var p in obj)
            if (obj.hasOwnProperty(p)) {
                str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
            }
        return str.join("&");
    },
    average: function (numArray) {
        var total = 0;
        for (var i = 0; i < numArray.length; i++) {
            total += numArray[i];
        }
        return total / numArray.length;
    }
}
