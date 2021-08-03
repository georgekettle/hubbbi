import { Controller } from "stimulus"
var dragula = require("dragula")
var autoScroll = require('dom-autoscroller')

export default class extends Controller {
  static targets = ["dropzone", "scrollContainer"]
  static values = { url: String }

  connect() {
    this.initDragula()
  }

  initDragula() {
    this.dragula = dragula(this.dropzoneTargets, {
      revertOnSpill: true,
      removeOnSpill: true,
      direction: 'vertical',
      copy: true,
      moves: function (el, container, handle) {
        return el.classList.contains('handle');
      }
    });

    // autoscroll on drag
    this.setupAutoScroll()

    this.setupDragStart()
    this.setupDropzoneHover()
    this.setupDropzoneHoverExit()
    this.setupDropzoneDrop()
    this.setupDragEnd()
  }

  setupAutoScroll() {
    if (this.hasScrollContainerTarget) {
      const dragulaObject = this.dragula
      this.scroll = autoScroll(this.scrollContainerTargets, {
          margin: 200,
          maxSpeed: 20,
          scrollWhenOutside: true,
          autoScroll: function(){
              //Only scroll when the pointer is down, and there is a child being dragged.
              return this.down && dragulaObject.dragging;
          }
      });
    }
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
    target.parentElement.insertAdjacentHTML('beforebegin', data.section)
    let newSection = target.parentElement.previousElementSibling
    let newDropzone = newSection.querySelector('.dropzone')
    controller.dragula.containers.push(newDropzone)
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
