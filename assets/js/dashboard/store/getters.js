export default {
    userName: state => {
        return state.userRecord.email.split('@')[0]
    },
    selectedSession: state => {
        for (var i = 0; i < state.sessions.length; i++) {
            const curSession = state.sessions[i]
            if (curSession.id == state.selectedSessionId) {
                return curSession;
            }
        }
        return null;
    }
}