import { Controller } from '@hotwired/stimulus'
import { saveAs } from 'file-saver'

export default class extends Controller {
  static values = {
    name: String
  }

  connect() {
    console.log('download controller')
  }

  download(e) {
    e.preventDefault()
    // download this.element.src
    // saveAs(this.element.href, "image.jpg")
    if (this.hasNameValue) {
      saveAs(this.element.href, this.nameValue)
    } else {
      saveAs(this.element.href)
    }
  }
}
