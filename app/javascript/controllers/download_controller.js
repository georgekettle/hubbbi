import { Controller } from '@hotwired/stimulus'
import { saveAs } from 'file-saver'

export default class extends Controller {
  static values = {
    name: String
  }

  download(e) {
    e.preventDefault()
    if (this.hasNameValue) {
      saveAs(this.element.href, this.nameValue)
    } else {
      saveAs(this.element.href)
    }
  }
}
