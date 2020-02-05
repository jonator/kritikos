// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import dashboardCss from "../css/dashboard.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";
import Vue from "vue";
import VueRouter from "vue-router";
import VueToasted from "vue-toasted";
import store from "./dashboard/store";
import Dashboard from "./dashboard/components/Dashboard.vue";
import MyProfile from "./dashboard/components/subviews/MyProfile.vue";
import Sessions from "./dashboard/components/subviews/Sessions.vue";
import Session from "./dashboard/components/subviews/Session.vue";

Vue.use(VueRouter)
Vue.use(VueToasted)

// Lets Register a Global Error Notification Toast.
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
    { id: 0, path: "/my-profile", component: MyProfile },
    { id: 1, path: "/sessions", component: Sessions },
    { id: 3, path: "/sessions/:keyword", component: Session },
    { path: "*", redirect: "/sessions" }
]

var router = new VueRouter({
    routes
})

new Vue({
    router,
    store,
    el: "#dashboard",
    render: h => h(Dashboard)
})
