import { Controller } from "@hotwired/stimulus"
import "flipbook"

export default class extends Controller {
  static targets = ["pdf"]
  static values = { 
    pdfUrl: String,
    pages: Array 
  }

  connect() {
    console.log("Flipbook controller connected")
    console.log(this.pdfTarget)
    
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
    let options = {
      // Set the script paths to prevent dynamic loading issues
      flipbookSrc: "/assets/flipbook/build/js/flipbook.min.js",
      // Disable license checking for development (use only for testing)
      deeplinkingEnabled: false,
    }

    // If you have a PDF URL
    if (this.hasPdfUrlValue && this.pdfUrlValue) {
      options = {
        pdfUrl: this.pdfUrlValue,
        // PDF-specific options
        btnDownloadPdf: {
          enabled: true,
          url: this.pdfUrlValue
        }
      }
    }
    // If you have image pages
    else if (this.hasPagesValue && this.pagesValue.length > 0) {
      options = {
        pages: this.pagesValue
      }
    }
    // Default example pages for testing
    else {
      options.pages = [
        {
          src: 'https://via.placeholder.com/800x600/cccccc/969696?text=Page+1',
          thumb: 'https://via.placeholder.com/150x112/cccccc/969696?text=Page+1',
        },
        {
          src: 'https://via.placeholder.com/800x600/cccccc/969696?text=Page+2', 
          thumb: 'https://via.placeholder.com/150x112/cccccc/969696?text=Page+2',
        }
      ]
    }

    // Common options
    Object.assign(options, {
      lightBox: false,
      height: 600,
      width: 800,
      // Disable features that might cause license issues
      googleAnalyticsTrackingCode: null,
      btnShare: { enabled: false },
      btnDownloadPages: { enabled: false },
      btnPrint: { enabled: false }
    })
    
    try {
      // Create the flipbook instance
      this.flipbook = new FlipBook(container, options)
      console.log('Flipbook initialized successfully')
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
