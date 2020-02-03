import Vue from "vue";
import Vuex from "vuex";
import mutations from "./mutations";
import actions from "./actions";
import getters from "./getters";
import utils from "./utils";

Vue.use(Vuex);

export default new Vuex.Store({
    state: {
        userRecord: initialState.userRecord,
        sessions: initialState.sessions.map(utils.presentSession),
        sessionsFilters: {
            filterTags: []
        },
        currentModalName: null,
        modalState: null,
        errors: []
    },
    actions,
    mutations,
    getters
})
