import { Controller } from "@hotwired/stimulus"

let id = 0

export default class extends Controller {
  static targets = ["content", "close"]
  static values = {
    id: Number
  }

  initialize() {
    this.idValue = id++
    this.setupCloseButtons()
  }

  connect() {
    this.createLightbox()
    this.populateLightbox()
  }

  disconnect() {
    Array.from(this.lightboxTarget.children).forEach((elem) => {
      this.contentTarget.append(elem)
    })
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
    Array.from(this.contentTarget.children).forEach((elem) => {
      this.lightboxTarget.append(elem)
    })
  }

  open(e) {
    e.preventDefault()
    if (document.body.dataset.dragging === 'false') {
      this.lightboxTarget.classList.add('active')
    }
  }

  close(e) {
    e.preventDefault()
    this.lightboxTarget.classList.remove('active')
  }
}
