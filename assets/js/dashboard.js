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
import store from "./dashboard/store";
import Dashboard from "./dashboard/components/Dashboard.vue";

new Vue({
    store,
    el: "#dashboard",
    render: h => h(Dashboard)
})
