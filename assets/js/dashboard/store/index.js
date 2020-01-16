import Vue from "vue";
import Vuex from "vuex";
import mutations from "./mutations";
import actions from "./actions";
import getters from "./getters";

Vue.use(Vuex);

var state = {}

state.userRecord = initialStore.userRecord; // server side generated

export default new Vuex.Store({
    state: state,
    actions,
    mutations,
    getters
})

initialStore.sessions.forEach(session => {
    mutations.incorporateSession(state, session)
});
