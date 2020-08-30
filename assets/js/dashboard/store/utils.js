import utils from "../../utils";
import moment from "moment";

const FREE_FEEDBACKS_COUNT = 400;
var FREE_FEEDBACKS_IDS = [];
const lorem_ipsum = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis."

const dashboardUtils = {
    presentVote: vote => {
        if (vote.feedback && initialState.userRecord.subscriptionStatus == "free") {
            if (FREE_FEEDBACKS_IDS.length < FREE_FEEDBACKS_COUNT) {
                FREE_FEEDBACKS_IDS.push(vote.feedback.id);
            } else if (!FREE_FEEDBACKS_IDS.includes(vote.feedback.id)) {
                vote.feedback.freeTierHidden = true;
                vote.feedback.text = lorem_ipsum;
            }
        }
        return vote;
    },
    presentSession: (session) => {
        session.link = window.location.origin + '/' + session.keyword;
        session.isEnded = session.endDatetime != null;
        if (!session.votes) session.votes = [];
        session.votes.sort((a, b) => a.id - b.id).map(dashboardUtils.presentVote);
        return session;
    }
}

export default dashboardUtils;