import { Controller } from "stimulus";

import PasswordVisibility from "@stimulus-components/password-visibility"

export default class extends PasswordVisibility {
    connect() {
        super.connect()
    }

    toggle(event) {
        super.toggle()
    }
}
