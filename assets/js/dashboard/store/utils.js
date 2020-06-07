import utils from "../../utils";
import moment from "moment";

var FREE_FEEDBACKS_COUNT = 400;
const lorem_ipsum = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis."

const dashboardUtils = {
    calcSessionVoteActivity: (votes) => {
        var timeDurations = [];
        for (var i = 1; i < votes.length; i++) {
            const prevVoteDatetime = moment(votes[i - 1].voteDatetime);
            const curVoteDatetime = moment(votes[i].voteDatetime);
            const timeDuration = moment
                .duration(prevVoteDatetime.diff(curVoteDatetime))
                .as("ms");
            timeDurations.push(timeDuration);
        }
        const averageDuration = utils.average(timeDurations);
        return moment.duration(averageDuration).humanize() + " between votes";
    },
    hideFreeTierFeedbackData: votes => {
        votes.forEach(vote => {
            if (FREE_FEEDBACKS_COUNT > 0) {
                FREE_FEEDBACKS_COUNT--;
            } else {
                vote.feedback.freeTierHidden = true
                vote.feedback.text = lorem_ipsum;
            }
        });
    },
    presentSession: (session) => {
        session.link = window.location.origin + '/' + session.keyword;
        session.isEnded = session.endDatetime != null;
        session.activity = session.votes && session.votes.length > 4 ? dashboardUtils.calcSessionVoteActivity(session.votes) : "little to none";
        if (!session.votes) session.votes = [];
        if (initialState.userRecord.subscriptionStatus == "free") dashboardUtils.hideFreeTierFeedbackData(session.votes);
        return session;
    }
}

export default dashboardUtils;