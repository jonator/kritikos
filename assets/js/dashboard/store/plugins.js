import { Socket } from "phoenix";

var dashboardSocketPlugin = store => {
    const error = e => console.error("SOCKER ERR", e)
    var phoenixSocket = new Socket("/socket")
    phoenixSocket.connect({ token: userToken })
    phoenixSocket.onError(error)
    var dashboardChannel = phoenixSocket.channel("dashboard:" + store.state.userRecord.id)
    dashboardChannel.join()
        .receive("ok", () => console.log("DASHBOARD_SOCKET", "joined dashboard channel"))
    dashboardChannel.onError(error)
    dashboardChannel.on("update_model", m => store.commit("incorporateModel", m))
}


export default
    [dashboardSocketPlugin]

