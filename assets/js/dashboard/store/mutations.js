import utils from "./utils";

export default {
    addErrors: (state, errors) => {
        console.error("ERROR", errors);
        if (errors) state.errors = errors
        else state.errors = ["There was a problem performing that action"]
    },
    selectSubViewIndex: (state, index) => {
        state.currentSubViewIndex = index
    },
    incorporateModel: (state, model) => {
        if (model["session"]) {
            const newSession = model["session"]
            var existingSession = state.sessions.find(s => {
                return s.id == newSession.id
            })
            if (existingSession) {
                Object.assign(existingSession, utils.presentSession(newSession))
            } else {
                var s = utils.presentSession(newSession)
                state.sessions.push(s)
            }
        } else if (model["vote"]) {
            const newVote = model["vote"]
            var vote = state.sessions.reduce((acc, s) => acc.concat(s.votes), []).find(v => v.id == newVote.id)
            var session = state.sessions.find(s => s.id == newVote.sessionId)
            if (vote && session) {
                Object.assign(vote, newVote)
            } else if (session) {
                session.votes.push(newVote)
            }
        } else {
            console.error("INVALID MODEL", model)
        }
    },
    removeModel: (state, model) => {
        if (model["session"]) {
            state.sessions = state.sessions.filter(s => s.id != model.session.id)
        }
    },
    clearSessionsFilters: state => {
        state.sessionsFilters.filterTags = []
    },
    openModal: (state, { form, initialState }) => {
        state.currentModalName = form
        state.modalState = initialState
    },
    dismissModal: state => {
        state.currentModalName = null
    },
    updateSessionsFilter: (state, filterState) => {
        Object.assign(state.sessionsFilters, filterState)
    },
    toggleSessionInfoDrawer: (state) => {
        state.sessionInfoDrawerOpen = !state.sessionInfoDrawerOpen
    }
}