import utils from "./utils";

export default {
    addErrors: (state, errors) => {
        if (errors) state.errors = errors
        else state.errors = ["There was a problem performing that action"]
    },
    incorporateSession: (state, session) => {
        var s = state.sessions.find(s => {
            return s.id == session.id
        })
        if (s) {
            Object.assign(s, session)
        } else {
            var newSession = utils.presentSession(session)
            state.sessions.push(newSession)
        }
    },
    selectSession: (state, sessionId) => {
        state.selectedSessionId = sessionId
    },
    deselectSession: state => {
        state.selectedSessionId = null
    },
    openModal: (state, componentName) => {
        state.currentModalName = componentName
    },
    dismissModal: state => {
        state.currentModalName = null
    }
}