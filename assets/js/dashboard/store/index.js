import Vue from "vue";
import Vuex from "vuex";
import mutations from "./mutations";
import actions from "./actions";
import getters from "./getters";
import utils from "./utils";
import plugins from "./plugins";

Vue.use(Vuex);

// Only display oldest 'x' free votes
initialState.sessions.reduce((acc, s) => acc.concat(s.votes.filter(v => v.feedback != null && v.feedback != undefined)), []).sort((a, b) => a.feedback.id - b.feedback.id).map(utils.presentVote)

export default new Vuex.Store({
    state: {
        userRecord: initialState.userRecord,
        sessions: initialState.sessions.map(utils.presentSession),
        sessionInfoDrawerOpen: false,
        voteLevels: voteLevels.reverse(),
        sessionsFilters: {
            filterTags: []
        },
        stripe: {
            client: initialState.stripeClient
        },
        currentModalName: null,
        modalState: null,
        errors: []
    },
    actions,
    mutations,
    getters,
    plugins
})
