import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["container", "button", "popup", "background"]

  show(e) {
    e.preventDefault()
    this.containerTarget.classList.add('active')
    this.buttonTarget.dataset.action = 'click->popup-options#hide'
    this.preventBodyScroll()
  }

  hide(e) {
    e.preventDefault()
    this.containerTarget.classList.remove('active')
    this.buttonTarget.dataset.action = 'click->popup-options#show'
    this.permitBodyScroll()
  }

  preventBodyScroll() {
    // When the modal is shown, we want overflow-hidden
    document.body.classList.add('modal-open')
  }

  permitBodyScroll() {
    // When the modal is hidden...
    document.body.classList.remove('modal-open')
  }
}
