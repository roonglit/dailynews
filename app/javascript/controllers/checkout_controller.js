import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    omiseKey: String,
    amount: Number
  }

  static targets = ["form", "token"]


  connect() {
    console.log("Checkout controller connected")
    // Destroy any existing Omise instance to ensure clean state
    if (typeof OmiseCard !== 'undefined' && OmiseCard.destroy) {
      OmiseCard.destroy()
    }

    // Configure OmiseCard - this creates the iframe
    OmiseCard.configure({
      publicKey: this.omiseKeyValue,
      image: 'https://cdn.omise.co/assets/dashboard/images/omise-logo.png',
      frameLabel: 'Dailynews',
    });
  }

  disconnect() {
    console.log("Checkout controller disconnected")
    // Destroy the Omise instance completely
    if (typeof OmiseCard !== 'undefined' && OmiseCard.destroy) {
      OmiseCard.destroy()
    }
  }

  payButtonClicked(e) {
    e.preventDefault()

    console.log("Checkout clicked")

    OmiseCard.open({
      amount: this.amountValue,
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