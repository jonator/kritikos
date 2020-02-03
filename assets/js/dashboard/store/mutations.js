import utils from "./utils";

export default {
    addErrors: (state, errors) => {
        if (errors) state.errors = errors
        else state.errors = ["There was a problem performing that action"]
    },
    selectSubViewIndex: (state, index) => {
        state.currentSubViewIndex = index
    },
    incorporateSession: (state, session) => {
        var s = state.sessions.find(s => {
            return s.id == session.id
        })
        if (s) {
            Object.assign(s, utils.presentSession(session))
        } else {
            var newSession = utils.presentSession(session)
            state.sessions.push(newSession)
        }
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
    }
}