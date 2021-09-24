// import Dropdown from "stimulus-dropdown"

// export default class extends Dropdown {
//   connect() {
//     super.connect();
//   }

//   toggle (event) {
//     this.toggleTransition()
//   }

//   open(event) {
//     // use if toggle not working
//     this.enter();
//     let button = event.currentTarget
//     let newActions = button.dataset.action.split(" ").map((action) => {
//       return action === "dropdown#open" ? "dropdown#close" : action
//     })
//     button.dataset.action = newActions.join(' ')
//   }

//   close(event) {
//     // only used if toggle not working
//     this.leave();
//     let button = event.currentTarget
//     let newActions = button.dataset.action.split(" ").map((action) => {
//       return action === "dropdown#close" ? "dropdown#open" : action
//     })
//     button.dataset.action = newActions.join(' ')
//   }

//   hide (event) {
//     if (!this.element.contains(event.target) && !this.menuTarget.classList.contains('hidden')) {
//       this.leave()
//     }
//   }
// }

// import { Controller } from 'stimulus'
// import { useTransition } from 'stimulus-use/dist/use-transition'

// export default class extends Controller {
//   menuTarget: HTMLElement
//   toggleTransition: (event?: Event) => void
//   leave: (event?: Event) => void
//   transitioned: false

//   static targets = ['menu']

//   connect (): void {
//     useTransition(this, {
//       element: this.menuTarget
//     })
//   }

//   toggle (): void {
//     this.toggleTransition()
//   }

//   hide (event: Event): void {
//     // @ts-ignore
//     if (!this.element.contains(event.target) && !this.menuTarget.classList.contains('hidden')) {
//       this.leave()
//     }
//   }
// }
