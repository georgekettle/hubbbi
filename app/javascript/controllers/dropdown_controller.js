import Dropdown from "stimulus-dropdown"

export default class extends Dropdown {
  connect() {
    super.connect()
  }

  toggle (event) {
    this.toggleTransition()
  }

  open(event) {
    // use if toggle not working
    this.enter();
    let button = event.currentTarget
    let newActions = button.dataset.action.split(" ").map((action) => {
      return action === "dropdown#open" ? "dropdown#close" : action
    })
    button.dataset.action = newActions.join(' ')
  }

  close(event) {
    // only used if toggle not working
    this.leave();
    let button = event.currentTarget
    let newActions = button.dataset.action.split(" ").map((action) => {
      return action === "dropdown#close" ? "dropdown#open" : action
    })
    button.dataset.action = newActions.join(' ')
  }

  hide (event) {
    if (!this.element.contains(event.target) && !this.menuTarget.classList.contains('hidden')) {
      this.leave()
    }
  }
}
