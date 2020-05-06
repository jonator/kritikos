export default {
    userName: state => {
        return state.userRecord.email.split('@')[0]
    },
    filtersAreSet: state => {
        return state.sessionsFilters.filterTags.length > 0
    },
    filteredSessions: state => {
        const sessions = state.sessions;
        const filterTagsText = state.sessionsFilters.filterTags.map(
            ft => ft.text
        );
        if (filterTagsText.length == 0) return sessions;
        return sessions.filter(s => {
            const sessionTagsText = s.tags.map(st => st.text);
            var hasAllTags = true;
            filterTagsText.forEach(filterTag => {
                if (!sessionTagsText.includes(filterTag)) {
                    hasAllTags = false;
                }
            });
            return hasAllTags;
        });
    }
}