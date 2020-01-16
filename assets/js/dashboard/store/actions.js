import utils from "../../utils.js";

function apiRequestWithTokenAndErrors(method, url, body, commit, callback) {
    utils.apiRequest(method, url, { token: userToken, ...body }).then(jsonResp => {
        var errorsEncountered = false
        if (jsonResp.errors) {
            jsonResp.errors.array.forEach(err => {
                console.error(err);
            });
            commit("addErrors", jsonResp.errors)
            errorsEncountered = true
            delete jsonResp.errors
        }
        callback(jsonResp, errorsEncountered)
    })
}

export default {
    CREATE_SESSION: ({ commit, state }, tags) => {
        const body = {
            keyword: "TEST56",
            tags: tags.map(tag => { return { text: tag } })
        }
        apiRequestWithTokenAndErrors("POST", "/api/sessions/create", body, commit, (resp, didError) => {
            if (!didError) commit("incorporateSession", resp.session)
        })
    },
    SELECT_SESSION: ({ commit, state }, sessionId) => {
        commit("selectSession", sessionId)
    },
    DESELECT_SESSION: ({ commit, state }) => {
        commit("deselectSession")
    }
}