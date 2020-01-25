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
    SELECT_SUBVIEW_INDEX: ({ commit, state }, index) => {
        commit("selectSubViewIndex", index)
    },
    CREATE_SESSION: ({ commit, state }, session) => {
        apiRequestWithTokenAndErrors("POST", "/api/sessions/start", session, commit, (resp, didError) => {
            if (!didError) {
                commit("incorporateSession", resp.session)
                commit("dismissModal")
            }
        })
    },
    END_SESSION: ({ commit, state }, keyword) => {
        const reqBody = {
            keyword: keyword
        }
        apiRequestWithTokenAndErrors("POST", "/api/sessions/end", reqBody, commit, (resp, didError) => {
            if (!didError) commit("incorporateSession", resp.session)
        })
    },
    SELECT_SESSION: ({ commit, state }, sessionId) => {
        commit("selectSession", sessionId)
    },
    DESELECT_SESSION: ({ commit, state }) => {
        commit("deselectSession")
    },
    OPEN_MODAL: ({ commit, state }, componentName) => {
        commit("openModal", componentName)
    },
    DISMISS_MODAL: ({ commit, state }) => {
        if (confirm("Are you sure? Any changes will be lost")) {
            commit("dismissModal")
        }
    }
}