export default {
    userName: state => {
        return state.userRecord.email.split('@')[0]
    }
}