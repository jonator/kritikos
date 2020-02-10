import { Socket } from "phoenix";

export default class DashboardSocket {
    constructor(user_id, token, callbacks) {
        this.callbacks = callbacks
        this.phoenixSocket = new Socket("/socket")
        this.phoenixSocket.connect({ token: token })
        this.phoenixSocket.onError(this.error)
        this.phoenixSocket.onClose(this.close)
        this.dashboardChannel = this.phoenixSocket.channel("dashboard:" + user_id)
        this.dashboardChannel.join()
            .receive("ok", () => console.log("DASHBOARD_SOCKET", "joined dashboard channel"))
        this.dashboardChannel.onError(this.error)
        this.dashboardChannel.onClose(this.close)
        this.dashboardChannel.on("update_model", this.modelUpdated)
    }

    modelUpdated(model) {
        this.callbacks.modelUpdated(model)
    }

    error(e) {
        console.error("DASHBOARD_SOCKET_ERR", e)
        this.callbacks.error(e)
    }

    close() {
        console.log("DASHBOARD_SOCKET", "close")
        this.callbacks.close()
    }
}