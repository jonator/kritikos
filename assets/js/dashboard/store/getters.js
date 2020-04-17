export default {
    userName: state => {
        return state.userRecord.email.split('@')[0]
    },
    filtersAreSet: state => {
        return state.sessionsFilters.filterTags.length > 0
    }
}