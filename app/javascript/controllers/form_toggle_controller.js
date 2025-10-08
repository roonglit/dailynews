import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "input"]

  toggleButton() {
    let changed = false
    for (let input of this.inputTargets) {
        if (input.value !== input.defaultValue) {
            changed = true
            break
        }
    }

    this.buttonTarget.style.display = changed ? "block" : "none"
  }

  checkChange() {
    this.toggleButton()
  }
}
