import { Controller } from "stimulus"
// import Trix from "trix"

export default class extends Controller {
  static targets = ["editor", "toolbar"]
  static values = { url: String }

  initialize() {
    this.trix = require("trix")
    this.resetEditorInnerHTML()
    this.beforeInitialize()
    this.onFocus()
    this.onBlur()
    this.setOnChange()
  }

  beforeInitialize() {
    if (this.hasEditorTarget) {
      this.addH2()
      this.addH3()
    }
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

  setOnChange() {
    const controller = this

    this.editorTarget.addEventListener('trix-change', (e) => {
      if (this.requestTimout) clearTimeout(this.requestTimout);

      this.requestTimout = setTimeout(function(){
        controller.sendRequest(controller)
      }, 1000)
    })
  }

  sendRequest(controller) {
    controller.setSectionStatus("saving")
    controller.setPageStatus("saving")
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
    this.setSectionStatus("saved")
    this.setPageStatus("saved")
    const controller = this
    setTimeout(function(){ controller.unsetSaveStatus() }, 3000);
  }

  errorCallback(err) {
    console.log("ERROR")
  }

  addH2() {
    this.trix.config.blockAttributes.heading2 = {
      tagName: "h2",
      terminal: true,
      breakOnReturn: true,
      group: false
    }
  }

  addH3() {
    this.trix.config.blockAttributes.heading3 = {
      tagName: "h3",
      terminal: true,
      breakOnReturn: true,
      group: false
    }
  }

  setSectionStatus(status) {
    const savingBadge = this.element.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.add(status)
  }

  unsetSaveStatus() {
    const savingBadge = this.element.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.remove('saved', 'saving')
  }

  setPageStatus(status) {
    const pageSaveStatus = document.getElementById('edit-section-saving-badge')
    if (pageSaveStatus) {
      pageSaveStatus.classList.remove('saved', 'saving')
      pageSaveStatus.classList.add(status)
    }
  }
}
