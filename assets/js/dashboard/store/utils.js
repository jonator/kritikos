import getters from "./getters";

export default {
    presentSession: (session) => {
        session.link = window.location.origin + '/' + session.keyword;
        session.isEnded = session.endDatetime != null;
        if (session.votes) {
            session.voteCount = session.votes.length;
        } else {
            session.voteCount = null;
        }

        return session;
    }
}