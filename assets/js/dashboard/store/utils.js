import utils from "../../utils";
import moment from "moment";

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
    presentSession: (session) => {
        session.link = window.location.origin + '/' + session.keyword;
        session.isEnded = session.endDatetime != null;
        session.activity = session.votes && session.votes.length > 4 ? dashboardUtils.calcSessionVoteActivity(session.votes) : "little to none"
        if (!session.votes) session.votes = [];
        return session;
    }
}

export default dashboardUtils;