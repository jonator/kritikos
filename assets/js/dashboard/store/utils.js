export default {
    presentSession: (session) => {
        session.link = window.location.origin + '/' + session.keyword;
        session.isEnded = session.endDatetime != null;
        if (!session.votes) session.votes = [];
        return session;
    }
}