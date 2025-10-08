import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      setTimeout(() => this.element.remove())
    }, 1500)
  }
}
