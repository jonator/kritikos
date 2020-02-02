import baseUtils from "../../utils";

function apiRequestWithTokenAndErrors(method, url, body, commit, callback) {
    baseUtils.apiRequest(method, url + "?token=" + userToken, { ...body }).then(jsonResp => {
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
    FETCH_SESSION: ({ commit, state }, params) => {
        return new Promise((resolve, reject) => {
            var keyword = null
            if (params.id) {
                keyword = state.sessions.find(s => s.id == sessionId).keyword
            } else {
                keyword = params.keyword
            }
            apiRequestWithTokenAndErrors("GET", "/api/sessions/" + keyword, null, commit, (resp, didError) => {
                if (!didError) {
                    commit("incorporateSession", resp.session)
                    resolve()
                } else {
                    reject()
                }
            })
        });
    },
    END_SESSION: ({ commit, state }, keyword) => {
        apiRequestWithTokenAndErrors("POST", "/api/sessions/" + keyword + "/end", null, commit, (resp, didError) => {
            if (!didError) commit("incorporateSession", resp.session)
        })
    },
    EXPORT_SESSION: ({ commit, state }, keyword) => {
        baseUtils.download("/api/sessions/" + keyword + "/export/qr?token=" + userToken)

    },
    OPEN_MODAL: ({ commit, state }, modalState) => {
        commit("openModal", modalState)
    },
    DISMISS_MODAL: ({ commit, state }, modalChanged) => {
        if (modalChanged) {
            if (confirm("Are you sure? Any changes will be lost")) {
                commit("dismissModal")
            }
        } else {
            commit("dismissModal")
        }
    }
}