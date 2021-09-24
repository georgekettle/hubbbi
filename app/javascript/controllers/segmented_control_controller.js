import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "selection"]

  connect() {
    this.inputTargets = this.containerTarget.querySelectorAll('input')
    this.setup()
  }

  setup() {
    this.updatePillPosition(this)
    this.containerTarget.addEventListener("change", () => {this.updatePillPosition(this)});
    window.addEventListener("resize", () => {this.updatePillPosition(this)});
  }

  updatePillPosition(controller) {
    Array.from(controller.inputTargets).forEach((elem, index) => {
      const content = document.querySelector(`#${elem.id}-toggle-content`)
      if (elem.checked) {
        controller.moveBackgroundPillToElement(elem, index)
        if (content) content.style.display = ''
      } else {
        if (content) content.style.display = 'none'
      }
    })
  }

  moveBackgroundPillToElement(elem, index) {
    this.selectionTarget.style.transform = "translateX(" + (elem.offsetWidth * index) + "px)";
  }
}
