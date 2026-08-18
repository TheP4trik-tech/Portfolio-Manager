import { Controller } from "stimulus";

import PasswordVisibility from "@stimulus-components/password-visibility"

export default class extends PasswordVisibility {
    connect() {
        super.connect()

        // Do what you want here.
    }

    toggle(event) {
        super.toggle()

        // Do what you want here
    }
}
