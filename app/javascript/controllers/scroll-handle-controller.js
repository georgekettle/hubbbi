import { Controller } from "stimulus"
import OverlayScrollbars from 'overlayscrollbars'

export default class extends Controller {
  static targets = ["handle"]

  connect() {
    this.initOverlayScrollbars()
  }

  initOverlayScrollbars() {
    // SimpleScrollbar.initEl(this.element)
    OverlayScrollbars([this.element], {
      className: 'os-theme-round-dark'
    });
  }
}
