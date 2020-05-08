import "../css/dashboard.css"
import "phoenix_html";
import Vue from "vue";
import VueRouter from "vue-router";
import VueToasted from "vue-toasted";
import store from "./dashboard/store";
import Dashboard from "./dashboard/components/Dashboard.vue";
import Settings from "./dashboard/components/subviews/Settings.vue";
import Sessions from "./dashboard/components/subviews/Sessions.vue";
import Session from "./dashboard/components/subviews/Session.vue";
import SessionsOverview from "./dashboard/components/subviews/SessionsOverview.vue";

Vue.use(VueRouter)
Vue.use(VueToasted)

Vue.toasted.register('api_error',
    (payload) => {
        // if there is no message passed show default message
        if (!payload.message) {
            return "Oops.. Something Went Wrong.."
        }
        // if there is a message show it with the message
        return "Oops.. " + payload.message;
    },
    {
        type: 'error',
        duration: 5000
    }
)

const routes = [
    { id: 0, path: "/settings", component: Settings },
    { id: 1, path: "/sessions", component: Sessions },
    { id: 2, path: "/sessions/:keyword", component: Session },
    { id: 3, path: "/sessions-overview", component: SessionsOverview },
    { path: "*", redirect: "/sessions" }
]

var router = new VueRouter({
    routes
})

new Vue({
    router,
    store,
    el: "#dashboard-mount",
    render: h => h(Dashboard)
})
