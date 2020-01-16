import getters from "./getters"

export default {
    presentSession: (session) => {
        session.link = window.location.origin + '/' + session.keyword
        const userName = getters.userName;
        const urlParts = session.link.split("/");
        const urlId = urlParts[urlParts.length - 1];
        session.isPermanent = userName === urlId;
        return session;
    },
    addErrors: (state, errors) => {
        state.errors = errors
    },
    incorporateSession: (state, session) => {
        var newSession = this.presentSession(session)

        state.sessions = state.sessions.map(session => {
            if (session.id == newSession.id) {
                return newSession;
            } else {
                return session;
            }
        })
    },
    selectSession: (state, sessionId) => {
        state.selectedSessionId = sessionId
    },
    deselectSession: state => {
        state.selectedSessionId = null
    }
}