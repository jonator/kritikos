import utils from "../../utils";

export default {
    userName: state => {
        return state.userRecord.email.split('@')[0]
    },
    isMobile: state => {
        return utils.isMobile();
    },
    filtersAreSet: state => {
        return state.sessionsFilters.filterTags.length > 0
    },
    sessions: state => {
        return state.sessions.sort((leftS, rightS) => rightS.id - leftS.id) // descending
    },
    filteredSessions: (state, getters) => {
        const sessions = getters.sessions;
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