import { Controller } from "@hotwired/stimulus"

let id = 0

export default class extends Controller {
  static targets = ["content", "close"]
  static values = {
    id: Number
  }

  initialize() {
    this.idValue = id++
    this.createLightbox()
    this.setupCloseButtons()
    this.populateLightbox()
  }

  createLightbox() {
    this.lightboxTarget = document.createElement('div')
    this.lightboxTarget.classList.add('lightbox')
    this.lightboxTarget.id = `lightbox-${this.idValue}`
    document.body.appendChild(this.lightboxTarget)
  }

  setupCloseButtons() {
    const _this = this
    this.closeTargets.forEach((close) => {
      close.addEventListener('click', (e) => {
        _this.close(e)
      })
    })
  }

  populateLightbox() {
    const content = this.contentTarget
    this.lightboxTarget.insertAdjacentElement('beforeend', content)
    content.classList.remove('hidden')
  }

  open(e) {
    e.preventDefault()
    this.lightboxTarget.classList.add('active')
  }

  close(e) {
    e.preventDefault()
    this.lightboxTarget.classList.remove('active')
  }
}
