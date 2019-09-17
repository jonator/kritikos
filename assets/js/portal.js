import Vue from "vue";

new Vue({
    el: "#portal",
    data: {
        isRegistering: false,
        email: "",
        password: "",
        passwordConfirmation: "",
        errors: []
    },
    methods: {
        formIsValid() {
            return this.password.length > 0 &&
                this.email.length > 0 &&
                this.email.includes("@")
        },
        handleSubmit() {
            if (self.isRegistering) {

            } else {

            }
        },
        togglePortalMode() {
            this.isRegistering = !this.isRegistering;
        }
    }
})