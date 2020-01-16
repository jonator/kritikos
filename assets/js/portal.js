import Vue from "vue";
import utils from "./utils.js"

new Vue({
    el: "#portal",
    data: {
        isRegistering: false,
        name: "",
        email: "",
        password: "",
        passwordConfirmation: "",
        errors: []
    },
    methods: {
        handleSubmit() {
            this.errors = []
            if (this.isRegistering) {
                register(this.email, this.name, this.password, this.passwordConfirmation).then(this.processResponse)
            } else {
                signin(this.email, this.password).then(this.processResponse)
            }
        },
        togglePortalMode() {
            this.errors = []
            this.isRegistering = !this.isRegistering;
        },
        processResponse(response) {
            console.log(response)
            if (response.redirect) window.location.href = response.redirect
            response.errors.forEach(error => {
                this.errors.push(error)
            });
        }
    }
})

function register(email, name, password, passwordConfirmation) {
    const payload = { user: { email: email, profile: { name: name }, password: password, password_confirmation: passwordConfirmation } }
    return utils.apiRequest("POST", "/api/user", payload)
}

function signin(email, password) {
    const payload = { user: { email: email, password: password } }
    return utils.apiRequest("POST", "api/users/login", payload)
}