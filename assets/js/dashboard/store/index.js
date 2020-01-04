import Vue from "vue";
import Vuex from "vuex";
import mutations from "./mutations";
import actions from "./actions";
import getters from "./getters";

Vue.use(Vuex);

var state = initialStore; // server side generated

export default new Vuex.Store({
    state: state,
    actions,
    mutations,
    getters
})
