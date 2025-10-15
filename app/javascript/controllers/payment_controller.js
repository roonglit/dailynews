import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    omiseKey: String
  }

  static targets = ["form", "token"]


  connect() {
    OmiseCard.configure({
      publicKey: this.omiseKeyValue,
      image: 'https://cdn.omise.co/assets/dashboard/images/omise-logo.png',
      frameLabel: 'Dailynews',
    });
  }

  payButtonClicked(e) {
    e.preventDefault()
    
    console.log("Checkout clicked")

    OmiseCard.open({
      amount: 12345,
      currency: "THB",
      defaultPaymentMethod: "credit_card",
      onCreateTokenSuccess: (nonce) => {
        console.log("nonce: ", nonce);
        if (nonce.startsWith("tokn_")) {
          this.tokenTarget.value = nonce;
        } else {
          // set source value
        }

        this.formTarget.submit()
      }
    })
  }
}