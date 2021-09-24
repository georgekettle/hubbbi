import { Controller } from "@hotwired/stimulus"
import tippy from 'tippy.js';

export default class extends Controller {
  static targets = ["toggle", "menu"]
  static values = {
    hiddenClasses: Array,
    open: Boolean
  }

  connect () {
    tippy(this.toggleTargets, {
      content: this.menuTarget,
      arrow: false,
      interactive: true,
      moveTransition: 'transform 0.2s ease-out',
      offset: [0, 0],
      placement: 'bottom-end',
      trigger: 'mouseenter click',
      triggerTarget: this.toggleTargets,
    });
  }
}
