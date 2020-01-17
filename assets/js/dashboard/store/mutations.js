import utils from "./utils";

export default {
    addErrors: (state, errors) => {
        errors.forEach(err => {
            console.error(err)
            state.errors.push(err)
        });
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
    }
}