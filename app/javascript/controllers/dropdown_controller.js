// import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   static targets = ["menu"]
//   static values = {
//     hiddenClasses: Array,
//     open: Boolean
//   }

//   connect () {
//     if (!this.hasHiddenClassesValue) {
//       this.hiddenClassesValue = ["scale-0", "opacity-0"]
//     }
//     this.menuTarget.style.display = 'none'
//     !this.openValue && this.close()
//     this.menuTarget.style.display = null
//   }

//   containsHiddenClasses() {
//     let containsClass = false
//     this.hiddenClassesValue.forEach((hiddenClass) => {
//       containsClass = this.menuTarget.classList.contains(hiddenClass)
//     })
//     return containsClass
//   }

//   toggle (e) {
//     e.preventDefault()
//     this.containsHiddenClasses() ? this.open() : this.close()
//   }

//   open (e) {
//     e && e.preventDefault()
//     this.openValue = true
//     this.menuTarget.classList.remove(...this.hiddenClassesValue)
//   }

//   close (e) {
//     e && e.preventDefault()
//     this.openValue = false
//     this.menuTarget.classList.add(...this.hiddenClassesValue)
//   }

//   hide (e) {
//     const clickOnDropdown = this.element.contains(event.target)

//     if (!this.element.contains(event.target) && !this.menuTarget.classList.contains('hidden')) {

//     }
//   }
// }

import { Controller } from "@hotwired/stimulus"
import tippy from 'tippy.js';
import 'tippy.js/dist/tippy.css'; // optional for styling
import 'tippy.js/animations/scale.css';

export default class extends Controller {
  static targets = ["menu"]
  static values = {
    hiddenClasses: Array,
    open: Boolean
  }

  connect () {
    if (!this.hasHiddenClassesValue) {
      this.hiddenClassesValue = ["scale-0", "opacity-0"]
    }
    this.menuTarget.style.display = 'none'
    !this.openValue && this.close()
    this.menuTarget.style.display = null
  }

  containsHiddenClasses() {
    let containsClass = false
    this.hiddenClassesValue.forEach((hiddenClass) => {
      containsClass = this.menuTarget.classList.contains(hiddenClass)
    })
    return containsClass
  }

  toggle (e) {
    e.preventDefault()
    this.containsHiddenClasses() ? this.open() : this.close()
  }

  open (e) {
    e && e.preventDefault()
    this.openValue = true
    this.menuTarget.classList.remove(...this.hiddenClassesValue)
  }

  close (e) {
  }

  hide (e) {
  }
}
