import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["breadcrumb", "toggle"]
  expandNav() {
    this.breadcrumbTargets.forEach((breadcrumb) => {
      breadcrumb.classList.remove('hidden')
    })
    this.toggleTarget.classList.add('hidden')
  }
}
