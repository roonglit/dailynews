import { Controller } from "@hotwired/stimulus"
// Flipbook loaded globally via javascript_include_tag in layout

export default class extends Controller {
  static targets = ["pdf"]
  static values = { 
    pdfUrl: String,
    flipMp3: String
  }

  connect() {
    // Add a small delay to ensure scripts are loaded
    setTimeout(() => {
      this.initializeFlipbook()
    }, 100)
  }

  initializeFlipbook() {
    if (typeof FlipBook === 'undefined') {
      console.error('FlipBook is not available. Check if the library loaded correctly.')
      return
    }

    const container = this.pdfTarget
    
    // Configuration options for flipbook
    // All flipbook libraries are loaded globally via script tags in application layout
    let options = {
      pdfUrl: this.pdfUrlValue,
      
      // Sound configuration
      sound: true,              // Enable/disable sound
      flipSound: true,          // Enable page flip sound

      btnPrint: {enabled: false}, 
      btnDownloadPages: {enabled: false},
      btnDownloadPdf: {enabled: false },
      btnShare: {enabled: false },

      layout: "1",
    }
    
    // Set flip sound path if provided
    if (this.hasFlipMp3Value) {
      options.assets = {
        flipMp3: this.flipMp3Value
      }
    }

    // // Common options
    // Object.assign(options, {
    //   lightBox: false,
    //   height: 600,
    //   width: 800,
    //   // Disable features that might cause license issues
    //   googleAnalyticsTrackingCode: null,
    //   btnShare: { enabled: false },
    //   btnDownloadPages: { enabled: false },
    //   btnPrint: { enabled: false }
    // })
    
    try {
      // Create the flipbook instance
      this.flipbook = new FlipBook(container, options)
    } catch (error) {
      console.error('Error initializing flipbook:', error)
      
      // Fallback: show a simple message
      container.innerHTML = `
        <div style="padding: 20px; text-align: center; border: 1px solid #ccc;">
          <h3>Flipbook Library Issue</h3>
          <p>The flipbook library requires a valid license for commercial use.</p>
          <p>Error: ${error.message}</p>
          <p>Consider using an open-source alternative like turn.js or PDF.js</p>
        </div>
      `
    }
  }

  disconnect() {
    // Clean up when controller is disconnected
    if (this.flipbook && this.flipbook.destroy) {
      this.flipbook.destroy()
    }
  }
}
