import getters from "./getters"

export default {
    addErrors: (state, errors) => {
        state.errors = errors
    },
    incorporateSession: (state, session) => {
        if (!state.sessions) state.sessions = []
        session.link = window.location.origin + '/' + session.keyword
        state.sessions.push(session)
    }
}