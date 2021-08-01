import { Controller } from "stimulus"
var dragula = require("dragula")

export default class extends Controller {
  static targets = ["dropzone"]
  static values = { url: String }

  connect() {
    // this.initDroppable()
    this.initDragula()
  }

  initDragula() {
    this.dragula = dragula(this.dropzoneTargets, {
      revertOnSpill: true,
      removeOnSpill: true,
      copy: true,
      moves: function (el, container, handle) {
        return el.classList.contains('handle');
      }
    });

    this.setupDragStart()
    this.setupDropzoneHover()
    this.setupDropzoneHoverExit()
    this.setupDropzoneDrop()
    this.setupDragEnd()
  }

  setupDragStart() {
    this.dragula.on('drag', (el, source) => {
      // add active to dropzones
      this.dropzoneTargets.forEach((dropzone) => {
        dropzone.classList.add('active');
      })
    })
  }

  setupDropzoneHover() {
    this.dragula.on('over', (el, dropzone, source) => {
      dropzone.classList.add('hover-over')
    })
  }

  setupDropzoneHoverExit() {
    this.dragula.on('out', (el, dropzone, source) => {
      dropzone.classList.remove('hover-over')
    })
  }

  setupDropzoneDrop() {
    this.dragula.on('drop', (el, target, source, sibling) => {
      el.remove()
      this.dropzoneTargets.forEach((dropzone) => {
        dropzone.classList.remove('active');
      })
      let newSectionData = JSON.parse(el.dataset.createSection)
      newSectionData.section.position = parseInt(target.dataset.position)
      this.makeRequest(newSectionData, target, this.handleSuccess, this.handleError)
    })
  }

  setupDragEnd() {
    this.dragula.on('dragend', (el) => {
      this.dropzoneTargets.forEach((dropzone) => {
        dropzone.classList.remove('active');
      })
    })
  }

  updateDropzonePositions() {
    this.dropzoneTargets.forEach((dropzone, index) => {
      dropzone.setAttribute('data-position', index + 1)
    })
  }

  handleSuccess(data, target, controller) {
    target.insertAdjacentHTML('beforebegin', data.dropzone)
    let newDropzone = target.previousElementSibling
    target.insertAdjacentHTML('beforebegin', data.section)
    // newDropzone.setAttribute('data-drag-drop-editor-target', `dropzone`)
    controller.dragula.containers.push(newDropzone);
    // update the data-position of each drop dropzone to sit inline with UI
    controller.updateDropzonePositions()
  }

  handleError(err) {
    console.log(err)
  }

  makeRequest(sectionData, target, successCallback, errorCallback) {
    const controller = this
    let CSRFToken = document.querySelector('meta[name="csrf-token"]').content
    fetch(this.urlValue, {
      method: 'POST', // or 'PUT'
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': CSRFToken
      },
      body: JSON.stringify(sectionData),
    })
    .then(response => response.json())
    // .then(data => console.log(data))
    .then(data => successCallback(data, target, controller))
    .catch(err => errorCallback(err));
  }
}
