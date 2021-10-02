import { Controller } from '@hotwired/stimulus'
import { saveAs } from 'file-saver'

export default class extends Controller {
  static values = {
    name: String
  }

  download(e) {
    e.preventDefault()
    const isMobile = navigator.userAgentData.mobile;
    if (isMobile) {
      // alert to notify that page will navigate away
      if(confirm("This will open in a new page... Are you sure you'd like to do this?")) {
        this.startDownload()
      }
    } else {
      this.startDownload()
    }

  }

  startDownload() {
    if (this.hasNameValue) {
      saveAs(this.element.href, this.nameValue)
    } else {
      saveAs(this.element.href)
    }
  }
}
