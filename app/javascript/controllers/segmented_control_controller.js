import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["container", "selection"]

  connect() {
    this.inputTargets = this.containerTarget.querySelectorAll('input')
    this.setSelected()
    this.setup()
  }

  setSelected() {
    this.inputTargets.forEach((inputTarget) => {
      if (inputTarget.checked) {
        this.selected = inputTarget
      }
    })
  }

  setup() {
    const _this = this
    this.updatePillPosition(this)
    this.containerTarget.addEventListener("change", (e) => {
      this.selected = e.target
      this.uncheckNotSelected()
      this.updatePillPosition(this)
    });
    window.addEventListener("resize", () => { this.updatePillPosition(this) });
  }

  uncheckNotSelected() {
    this.inputTargets.forEach((inputTarget) => {
      if (inputTarget !== this.selected) {
        inputTarget.checked = false
      }
    })
  }

  updatePillPosition(controller) {
    controller.inputTargets.forEach((elem, index) => {
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
