import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["source"]
  static values = {
    active: {
      type: Boolean,
      default: false
    },
    height: {
      type: Number,
      default: 0
    },
    parentSelector: String
  }

  connect() {
    this.activeValue && this.open()
    this.setHeight()
  }

  setHeight() {
    this.heightValue = this.sourceTarget.offsetHeight
    const parent = document.querySelector(this.parentSelectorValue)
    if (parent && parent.offsetHeight < this.heightValue) {
      parent.style.height = `${this.heightValue}px`
    } else {
      this.sourceTarget.style.height = parent.style.height
    }
  }

  open() {
    this.setHeight()
    this.element.classList.add('z-10')
    this.sourceTarget.classList.remove('translate-x-full')
    this.sourceTarget.classList.add('translate-x-0')
  }

  close() {
    this.setHeight()
    this.element.classList.remove('z-10')
    this.sourceTarget.classList.remove('translate-x-0')
    this.sourceTarget.classList.add('translate-x-full')
  }
}