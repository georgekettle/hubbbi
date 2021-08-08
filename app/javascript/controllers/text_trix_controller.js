import { Controller } from "stimulus"
import * as Trix from "trix"

export default class extends Controller {
  static targets = ["editor", "toolbar"]
  static values = { url: String }

  initialize() {
    if (this.hasEditorTarget) this.resetEditorInnerHTML()

    this.addH2()
    this.addH3()

    this.onFocus()
    this.onBlur()
    this.onChange()
  }

  resetEditorInnerHTML() {
    this.editorTarget.innerHTML = this.editorTarget.dataset.value
  }

  onFocus() {
    this.editorTarget.addEventListener('trix-focus', (e) => {
      this.toolbarTarget.classList.remove('hidden')
    })
  }

  onBlur() {
    this.editorTarget.addEventListener('trix-blur', (e) => {
      this.toolbarTarget.classList.add('hidden')
    })
  }

  onChange() {
    const controller = this

    this.editorTarget.addEventListener('trix-change', (e) => {
      if (this.requestTimout) clearTimeout(this.requestTimout);
      this.requestTimout = setTimeout(function(){ controller.sendRequest(controller) }, 2000);
    })
  }

  sendRequest(controller) {
    controller.setAsSaving()
    let CSRFToken = document.querySelector('meta[name="csrf-token"]').content
    const textData = {
      text: {
        content: controller.editorTarget.value
      }
    }
    fetch(controller.urlValue, {
      method: 'PATCH', // or 'PUT'
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': CSRFToken
      },
      body: JSON.stringify(textData),
    })
    .then(response => response.json())
    // .then(data => console.log(data))
    .then(data => controller.successCallback(data))
    .catch(err => controller.errorCallback(err));
  }

  successCallback(data) {
    this.setAsSaved()
    const controller = this
    setTimeout(function(){ controller.unsetSaveStatus() }, 3000);
  }

  errorCallback(err) {
    console.log("ERROR")
  }

  addH2() {
    Trix.config.blockAttributes.heading2 = {
      tagName: "h2",
      terminal: true,
      breakOnReturn: true,
      group: false
    }
  }

  addH3() {
    Trix.config.blockAttributes.heading3 = {
      tagName: "h3",
      terminal: true,
      breakOnReturn: true,
      group: false
    }
  }

  setAsSaving() {
    const savingBadge = this.element.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.add('saving')
  }

  setAsSaved() {
    const savingBadge = this.element.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.add('saved')
  }

  unsetSaveStatus() {
    const savingBadge = this.element.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.remove('saved', 'saving')
  }
}
