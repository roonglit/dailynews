import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="poll-import-status"
export default class extends Controller {
  static values = {
    url: String,
    interval: { type: Number, default: 3000 } // Poll every 3 seconds
  }

  connect() {
    // Only start polling if there's a running import
    if (this.element.dataset.importRunning === "true") {
      this.startPolling()
    }
  }

  disconnect() {
    this.stopPolling()
  }

  startPolling() {
    this.poll()
    this.pollInterval = setInterval(() => {
      this.poll()
    }, this.intervalValue)
  }

  stopPolling() {
    if (this.pollInterval) {
      clearInterval(this.pollInterval)
    }
  }

  async poll() {
    try {
      const response = await fetch(this.urlValue, {
        headers: {
          "Accept": "text/vnd.turbo-stream.html"
        }
      })

      if (response.ok) {
        const html = await response.text()
        
        // Check if the import is no longer running
        // If the response doesn't contain "running" status, stop polling
        if (!html.includes('badge-info') && !html.includes('Running')) {
          this.stopPolling()
        }
        
        // Let Turbo handle the stream response
        Turbo.renderStreamMessage(html)
      }
    } catch (error) {
      console.error("Error polling import status:", error)
      // Continue polling even if there's an error
    }
  }
}
