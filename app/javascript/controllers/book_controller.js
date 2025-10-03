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
    
    // Set the flipbook source path to help with dynamic script loading
    if (window.FLIPBOOK) {
      window.FLIPBOOK.flipbookSrc = "/vendor/javascript/flipbook/build/js/flipbook.min.js"
    }
    
    this.initializeFlipbook()
  }

  initializeFlipbook() {
    const container = this.pdfTarget
    let options = {}

    // If you have a PDF URL
    if (this.hasPdfUrlValue && this.pdfUrlValue) {
      options = {
        pdfUrl: this.pdfUrlValue,
        // PDF-specific options
        btnDownloadPdf: {
          enabled: true,
          url: this.pdfUrlValue
        },
        // Set script paths for dynamic loading
        pdfjsSrc: "/vendor/javascript/flipbook/build/js/libs/pdf.min.js",
        pdfjsworkerSrc: "/vendor/javascript/flipbook/build/js/libs/pdf.worker.min.js",
        threejsSrc: "/vendor/javascript/flipbook/build/js/libs/three.min.js",
        iscrollSrc: "/vendor/javascript/flipbook/build/js/libs/iscroll.min.js",
        markSrc: "/vendor/javascript/flipbook/build/js/libs/mark.min.js",
        flipbookWebGlSrc: "/vendor/javascript/flipbook/build/js/flipbook.webgl.min.js",
        flipbookBook3Src: "/vendor/javascript/flipbook/build/js/flipbook.book3.min.js",
        flipBookSwipeSrc: "/vendor/javascript/flipbook/build/js/flipbook.swipe.min.js",
        flipBookScrollSrc: "/vendor/javascript/flipbook/build/js/flipbook.scroll.min.js",
        pdfServiceSrc: "/vendor/javascript/flipbook/build/js/flipbook.pdfservice.min.js"
      }
    }
    // If you have image pages
    else if (this.hasPagesValue && this.pagesValue.length > 0) {
      options = {
        pages: this.pagesValue
      }
    }
    // Default example pages
    else {
      options = {
        pages: [
          {
            src: 'path/to/your/image1.jpg',
            thumb: 'path/to/your/thumb1.jpg',
          },
          {
            src: 'path/to/your/image2.jpg', 
            thumb: 'path/to/your/thumb2.jpg',
          }
        ]
      }
    }

    // Common options
    Object.assign(options, {
      lightBox: false,
      height: 600,
      // Add other common options here
    })
    
    // Create the flipbook instance
    this.flipbook = new FlipBook(container, options)
  }

  disconnect() {
    // Clean up when controller is disconnected
    if (this.flipbook && this.flipbook.destroy) {
      this.flipbook.destroy()
    }
  }
}
