import { Controller } from "stimulus";

export default class extends Controller {

    static targets = ["unhide"]

    password(e) {
        if (this.input.type === "password") {
            e.target.classList.remove('fa-eye-slash');
            e.target.classList.add('fa-eye');
            this.input.type = "text";
        } else {
            e.target.classList.remove('fa-eye');
            e.target.classList.add('fa-eye-slash');
            this.input.type = "password";
        }
    }
}