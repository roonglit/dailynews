import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    omiseKey: String
  }

  static targets = [ "checkoutButton" ]

  connect() {
    console.log("targets:", this.checkoutButtonTarget)

    OmiseCard.configure({
      publicKey: this.omiseKeyValue,
      image: 'https://cdn.omise.co/assets/dashboard/images/omise-logo.png',
      frameLabel: 'Dailynews',
    });

    OmiseCard.configureButton("#payment-button", {
      buttonLabel: 'PAY Now 4,500 Baht',
      submitLabel: 'PAY NOW',
      amount: 450000
    });

    OmiseCard.attach();
  }

  checkout(e) {
    e.preventDefault()
    
    console.log("Checkout clicked")
  }
}