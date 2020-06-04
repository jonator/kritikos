import portalCss from "../css/portal.css";
import Vue from "vue";
import utils from "./utils.js"

const urlQueryParams = new URLSearchParams(window.location.search);

new Vue({
    el: "#portal",
    data: {
        isRegistering: urlQueryParams.get("register") === "true",
        firstLastName: "",
        email: "",
        password: "",
        passwordConfirmation: "",
        errors: []
    },
    methods: {
        handleSubmit() {
            this.errors = []
            var result = null
            if (this.isRegistering) {
                result = register(this.email, this.firstLastName, this.password, this.passwordConfirmation)
            } else {
                result = signin(this.email, this.password)
            }
            result.then((response) => {
                if (response.user) {
                    if (ref) {
                        window.location.href = ref
                    } else {
                        window.location.href = "/dashboard"
                    }
                } else if (response.errors) {
                    response.errors.forEach(error => {
                        this.errors.push(error)
                    });
                }
            })
        },
        togglePortalMode() {
            this.errors = []
            this.isRegistering = !this.isRegistering;
        }
    }
})

function register(email, firstLastName, password, passwordConfirmation) {
    const payload = { user: { email: email, first_last_name: firstLastName, password: password, password_confirmation: passwordConfirmation } }
    return utils.apiRequest("POST", "/api/user", payload)
}

function signin(email, password) {
    const payload = { user: { email: email, password: password } }
    return utils.apiRequest("POST", "api/users/login", payload)
}