import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    omiseKey: String,
    amount: Number
  }

  static targets = ["form", "token"]


  connect() {
    console.log("Omise controller connected")
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
    console.log("Omise controller disconnected")
    // Destroy the Omise instance completely
    if (typeof OmiseCard !== 'undefined' && OmiseCard.destroy) {
      OmiseCard.destroy()
    }
  }

  openForm(e) {
    e.preventDefault()

    console.log("Omise form triggered")

    const omiseOptions = {
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
      },
      onFormClosed: () => {
        console.log("User closed payment form.");
      },
      onCreateTokenError: (error) => {
        console.error("Omise token creation failed:", error);
      }
    }

    // Only add amount if it exists (for checkout flow)
    if (this.hasAmountValue) {
      omiseOptions.amount = this.amountValue
    }

    OmiseCard.open(omiseOptions)
  }

  // Keep backward compatibility with old checkout code
  payButtonClicked(e) {
    this.openForm(e)
  }
}