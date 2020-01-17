import getters from "./getters";

export default {
    presentSession: (session) => {
        session.link = window.location.origin + '/' + session.keyword
        session.isPermanent = getters.userName === session.keyword;
        return session;
    }
}