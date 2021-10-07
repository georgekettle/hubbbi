import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['button', 'buttonText', 'source']
  static values = {
    successDuration: {
      type: Number,
      default: 2000
    }
  }

  connect () {
    if (!this.hasButtonTarget) return

    if (this.hasButtonTextTarget) {
      this.originalText = this.buttonTextTarget.innerText
    } else {
      this.originalText = this.buttonTarget.innerText
    }
  }

  copy (event) {
    event.preventDefault()
    navigator.clipboard.writeText(this.sourceTarget.value);

    this.copied()
  }

  copied () {
    if (!this.hasButtonTarget) return

    if (this.timeout) {
      clearTimeout(this.timeout)
    }

    if (this.hasButtonTextTarget) {
      this.buttonTextTarget.innerText = this.data.get('successContent')
      this.timeout = setTimeout(() => {
        this.buttonTextTarget.innerText = this.originalText
      }, this.successDurationValue)
    } else {
      this.buttonTarget.innerText = this.data.get('successContent')
      this.timeout = setTimeout(() => {
        this.buttonTarget.innerText = this.originalText
      }, this.successDurationValue)
    }

  }
}
