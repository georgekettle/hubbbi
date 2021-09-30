import { Controller } from "@hotwired/stimulus"
var dragula = require("dragula")
var autoScroll = require('dom-autoscroller')

export default class extends Controller {
  static targets = ["item", "container", "scrollContainer"]
  static values = {
    handle: String,
    turboStream: Boolean,
    addToPosition: Number
  }

  connect() {
    this.initSortable()
    this.setupOnDrop()
  }

  initSortable() {
    let controller = this
    this.dragula = dragula(this.containerTargets, {
      revertOnSpill: true,
      removeOnSpill: false,
      moves: function (item, container, handle) {
        return handle.classList.contains(controller.handleValue);
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
      const position = controller.hasAddToPositionValue ? controller.getElementPosition(el) + controller.addToPositionValue : controller.getElementPosition(el)
      if (controller.turboStreamValue) {
        controller.turboStreamUpdateItem(el, position, controller.handleSuccess, controller.handleError)
      } else {
        controller.updateItem(el, position, controller.handleSuccess, controller.handleError)
      }
    })
  }

  setAsSaving(item) {
    const savingBadge = item.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.add('saving')
  }

  setAsSaved(item) {
    const savingBadge = item.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.add('saved')
  }

  unsetSaveStatus(item) {
    const savingBadge = item.querySelector('.saving-badge')
    savingBadge && savingBadge.classList.remove('saved', 'saving')
  }

  getElementPosition(el) {
    return Array.from(el.parentElement.children).indexOf(el) + 1
  }

  handleSuccess(data, item, controller) {
    // set as saved
    controller.setAsSaved(item)
    setTimeout(function(){ controller.unsetSaveStatus(item) }, 3000);
  }

  handleError(err) {
    console.log("ERROR:", err)
  }

  updateItem(item, position, successCallback, errorCallback) {
    const controller = this
    const body = JSON.parse(`{ "${item.dataset.elementName}": { "position": ${position} } }`)
    const url = `${item.dataset.url}.json`
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
    .then(data => successCallback(data, item, controller))
    .catch(err => errorCallback(err));
  }

  turboStreamUpdateItem(item, position, successCallback, errorCallback) {
    const body = JSON.parse(`{ "${item.dataset.elementName}": { "position": ${position} } }`)
    const url = item.dataset.url
    let CSRFToken = document.querySelector('meta[name="csrf-token"]').content

    fetch(url, {
      method: 'PATCH',
      headers: {
        'Accept': "text/vnd.turbo-stream.html",
        'Content-Type': 'application/json',
        'X-CSRF-Token': CSRFToken
      },
      body: JSON.stringify(body)
    })
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
  }
}
