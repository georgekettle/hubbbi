import { Controller } from "@hotwired/stimulus"
import tippy from 'tippy.js';

export default class extends Controller {
  static targets = ["toggle", "menu"]
  static values = {
    placement: String,
  }

  initialize () {
    this.placementValue ||= 'bottom-end'
    this.menu = this.menuTarget
  }

  connect() {
    if (this.hasMenuTarget && this.toggleTarget) {
      this.tippy = tippy(this.toggleTarget, {
        content: this.menuTarget,
        arrow: false,
        interactive: true,
        moveTransition: 'transform 0.05s ease-out',
        offset: [0, 0],
        placement: this.placementValue,
        trigger: 'mouseenter click',
        hideOnClick: true,
        triggerTarget: this.toggleTargets,
        appendTo: this.element,
        interactiveDebounce: 15,
      });
    }
  }

  disconnect () {
    if (this.tippy) {
      this.element.append(this.menu)
      this.tippy.destroy()
    }
  }
}
