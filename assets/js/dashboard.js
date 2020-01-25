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
import "phoenix_html"
import Vue from "vue";
import VueRouter from "vue-router";
import store from "./dashboard/store";
import Dashboard from "./dashboard/components/Dashboard.vue";
import MyProfile from "./dashboard/components/subviews/MyProfile.vue";
import Sessions from "./dashboard/components/subviews/Sessions.vue";

Vue.use(VueRouter)

const routes = [
    { id: 0, path: "/my-profile", component: MyProfile },
    { id: 1, path: "/sessions", component: Sessions },
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
