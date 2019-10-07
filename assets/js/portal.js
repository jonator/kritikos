import Vue from "vue";
import utils from "./utils.js"

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
        handleSubmit() {
            this.errors = []
            if (this.isRegistering) {
                register(this.email, this.password, this.passwordConfirmation).then(this.processResponse)
            } else {
                signin(this.email, this.password).then(this.processResponse)
            }
        },
        togglePortalMode() {
            this.errors = []
            this.isRegistering = !this.isRegistering;
        },
        processResponse(response) {
            if (response.error) this.errors.push(response.error)
            if (response.redirect) window.location.href = response.redirect
            for (var error_prop in response.errors) {
                var upperCaseProp = error_prop.charAt(0).toUpperCase() + error_prop.slice(1)
                upperCaseProp = upperCaseProp.replace("_", " ")
                const reasons = response.errors[error_prop]
                var allReasons = ""
                for (var i = 0; i < reasons.length; i++) {
                    if (i == reasons.length - 1) {
                        allReasons = allReasons.concat(reasons[i])
                    } else {
                        allReasons = allReasons.concat(reasons[i] + ', ')
                    }
                }
                this.errors.push(upperCaseProp + " " + allReasons)
            }
        }
    }
})

function register(email, password, passwordConfirmation) {
    const payload = { user: { email: email, password: password, password_confirmation: passwordConfirmation } }
    return utils.fetchData("POST", "/api/user", payload).then(r => r.json())
}

function signin(email, password) {
    const payload = { user: { email: email, password: password } }
    return utils.fetchData("POST", "api/users/login", payload).then(r => r.json())
}