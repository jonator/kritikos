export default {
    userId: state => {
        return state.user.email.split('@')[0]
    }
}