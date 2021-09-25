import { Controller } from "@hotwired/stimulus"
import tippy from 'tippy.js';

export default class extends Controller {
  static targets = ["toggle", "menu"]
  static values = {
    placement: String,
  }

  connect () {
    this.placementValue ||= 'bottom-end'
  }

  menuTargetConnected() {
    if (this.hasMenuTarget && this.toggleTarget) {
      this.tippy = tippy(this.toggleTarget, {
        content: this.menuTarget,
        arrow: false,
        interactive: true,
        moveTransition: 'transform 0.2s ease-out',
        offset: [0, 0],
        placement: this.placementValue,
        trigger: 'mouseenter click',
        triggerTarget: this.toggleTargets,
        appendTo: document.body
      });
    }
  }
}
