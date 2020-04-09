import Vue from "vue";
import Vuex from "vuex";
import mutations from "./mutations";
import actions from "./actions";
import getters from "./getters";
import utils from "./utils";
import plugins from "./plugins";

Vue.use(Vuex);

export default new Vuex.Store({
    state: {
        userRecord: initialState.userRecord,
        sessions: initialState.sessions.map(utils.presentSession),
        sessionInfoDrawerOpen: false,
        voteLevels: voteLevels,
        sessionsFilters: {
            filterTags: []
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
