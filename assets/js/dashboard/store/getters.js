export default {
    userName: state => {
        return state.userRecord.email.split('@')[0]
    },
    selectedSession: state => {
        if (state.selectedSessionId == null) return null;
        for (var i = 0; i < state.sessions.length; i++) {
            const curSession = state.sessions[i]
            if (curSession.id == state.selectedSessionId) {
                return curSession;
            }
        }
        return null;
    },
    filtersAreSet: state => {
        return state.sessionsFilters.filterTags.length > 0
    }
}