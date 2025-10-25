import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    type: String,
    labels: Array,
    data: Array,
    label: String,
    borderColor: { type: String, default: 'rgb(99, 102, 241)' },
    backgroundColor: { type: String, default: 'rgba(99, 102, 241, 0.1)' },
    fill: { type: Boolean, default: false },
    tension: { type: Number, default: 0.4 }
  }

  connect() {
    // Chart.js is loaded as a global via UMD
    if (typeof window.Chart === 'undefined') {
      console.error('Chart.js not loaded')
      return
    }

    this.initializeChart()
  }

  disconnect() {
    if (this.chart) {
      this.chart.destroy()
    }
  }

  initializeChart() {
    const ctx = this.element.getContext('2d')

    const chartType = this.typeValue || 'line'

    const data = {
      labels: this.labelsValue,
      datasets: [{
        label: this.labelValue || 'Data',
        data: this.dataValue,
        fill: this.fillValue,
        borderColor: this.borderColorValue,
        backgroundColor: this.backgroundColorValue,
        tension: this.tensionValue,
        borderRadius: chartType === 'bar' ? 8 : 0,
        borderSkipped: false
      }]
    }

    const config = {
      type: chartType,
      data: data,
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: {
            display: false
          },
          tooltip: {
            backgroundColor: 'rgba(0, 0, 0, 0.8)',
            padding: 12,
            cornerRadius: 8,
            titleColor: '#fff',
            bodyColor: '#fff'
          }
        },
        scales: {
          x: {
            grid: {
              display: false
            },
            ticks: {
              color: 'rgba(0, 0, 0, 0.6)'
            }
          },
          y: {
            beginAtZero: true,
            grid: {
              color: 'rgba(0, 0, 0, 0.05)',
              drawBorder: false
            },
            ticks: {
              color: 'rgba(0, 0, 0, 0.6)'
            }
          }
        }
      }
    }

    this.chart = new window.Chart(ctx, config)
  }
}
