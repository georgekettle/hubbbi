import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["source"]

  open() {
    this.element.classList.add('z-10')
    this.sourceTarget.classList.remove('translate-x-full')
    this.sourceTarget.classList.add('translate-x-0')
  }

  close() {
    this.element.classList.remove('z-10')
    this.sourceTarget.classList.remove('translate-x-0')
    this.sourceTarget.classList.add('translate-x-full')
  }
}