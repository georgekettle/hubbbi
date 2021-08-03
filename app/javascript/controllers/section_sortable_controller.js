import { Controller } from "stimulus"
var dragula = require("dragula")
var autoScroll = require('dom-autoscroller')

export default class extends Controller {
  static targets = ["item", "container", "scrollContainer"]

  connect() {
    this.initSortable()
    this.setupOnDrop()
  }

  initSortable() {
    this.dragula = dragula(this.containerTargets, {
      revertOnSpill: true,
      removeOnSpill: false,
      moves: function (item, container, handle) {
        return handle.classList.contains('handle');
      }
    });

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

  setupOnDrop() {
    const controller = this
    this.dragula.on('drop', (el, target, source, sibling) => {
      controller.setAsSaving(el)
      controller.updatePositions()
      const position = controller.getElementPosition(el)
      controller.updateSection(el, position, controller.handleSuccess, controller.handleError)
    })
  }

  setAsSaving(section) {
    const savingBadge = section.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.add('saving')
  }

  setAsSaved(section) {
    const savingBadge = section.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.add('saved')
  }

  unsetSaveStatus(section) {
    const savingBadge = section.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.remove('saved', 'saving')
  }

  getElementPosition(el) {
    return Array.from(el.parentElement.children).indexOf(el) + 1
  }

  updatePositions() {
    let dropzones = document.querySelectorAll('.dropzone')
    dropzones.forEach((dropzone, index) => {
      dropzone.setAttribute('data-position', index + 1)
    })
  }

  handleSuccess(data, section, controller) {
    // set as saved
    controller.setAsSaved(section)
    setTimeout(function(){ controller.unsetSaveStatus(section) }, 3000);
  }

  handleError(err) {
    console.log("ERROR:", err)
  }

  updateSection(section, position, successCallback, errorCallback) {
    const controller = this
    const url = `${section.dataset.updateUrl}.json`
    const body = {
      section: {
        position: position
      }
    }
    let CSRFToken = document.querySelector('meta[name="csrf-token"]').content
    fetch(url, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': CSRFToken
      },
      body: JSON.stringify(body),
    })
    .then(response => response.json())
    // .then(data => console.log(data))
    .then(data => successCallback(data, section, controller))
    .catch(err => errorCallback(err));
  }
}
