import DashboardSocket from "../dashboard_socket";

const dashboardSocketPlugin = (socketRef) => store => {
    socketRef = new DashboardSocket(store.state.userRecord.id, userToken, {
        modelUpdated: function (newModelObject) {
            store.commit("incorporateNewModel", newModelObject)
        },
        error: function (e) {
            store.commit("addErrors", [e])
        },
        close: function () {
        }
    })
}

var socketRef = {}

export default
    [dashboardSocketPlugin(socketRef)]
