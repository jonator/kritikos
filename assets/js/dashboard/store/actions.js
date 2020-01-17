import baseUtils from "../../utils";

function apiRequestWithTokenAndErrors(method, url, body, commit, callback) {
    baseUtils.apiRequest(method, url, { token: userToken, ...body }).then(jsonResp => {
        var errorsEncountered = false
        if (jsonResp.errors) {
            commit("addErrors", jsonResp.errors)
            errorsEncountered = true
            delete jsonResp.errors
        }
        callback(jsonResp, errorsEncountered)
    })
}

export default {
    CREATE_SESSION: ({ commit, state }, tags) => {
        const reqBody = {
            keyword: "TEST " + state.sessions.length,
            tags: tags.map(tag => { return { text: tag } })
        }
        apiRequestWithTokenAndErrors("POST", "/api/sessions/start", reqBody, commit, (resp, didError) => {
            if (!didError) commit("incorporateSession", resp.session)
            else commit("addErrors", resp.errors)
        })
    },
    END_SESSION: ({ commit, state }, keyword) => {
        const reqBody = {
            keyword: keyword
        }
        apiRequestWithTokenAndErrors("POST", "/api/sessions/end", reqBody, commit, (resp, didError) => {
            if (!didError) commit("incorporateSession", resp.session)
            else commit("addErrors", resp.errors)
        })
    },
    SELECT_SESSION: ({ commit, state }, sessionId) => {
        commit("selectSession", sessionId)
    },
    DESELECT_SESSION: ({ commit, state }) => {
        commit("deselectSession")
    }
}