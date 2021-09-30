import { Controller } from "@hotwired/stimulus"
var Flickity = require('flickity');
require('flickity-imagesloaded');

export default class extends Controller {
  static targets = ["container", "buttons"]

  connect() {
    this.initSlider()
    this.moveNavButtons()
    this.initOnDragStart()
    this.initOnDragEnd()
  }

  initSlider() {
    this.flkty = new Flickity(this.containerTarget, {
      // options
      cellAlign: 'left',
      contain: true,
      imagesLoaded: true,
      touchVerticalScroll: false,
      arrowShape: 'M45.5471172,50 L63.8417405,68.2614206 C65.3860865,69.8029639 65.3860865,72.3022993 63.8417405,73.8438426 C62.2973944,75.3853858 59.7935147,75.3853858 58.2491687,73.8438426 L37.1582595,52.791211 C35.6139135,51.2496677 35.6139135,48.7503323 37.1582595,47.208789 L58.2491687,26.1561574 C59.7935147,24.6146142 62.2973944,24.6146142 63.8417405,26.1561574 C65.3860865,27.6977007 65.3860865,30.1970361 63.8417405,31.7385794 L45.5471172,50 Z'
    });
  }

  moveNavButtons() {
    const navButtons = this.element.querySelectorAll('.flickity-prev-next-button')
    Array.from(navButtons).forEach((button) => {
      this.buttonsTarget.insertAdjacentElement('beforeend', button)
    })
  }

  initOnDragStart() {
    this.flkty.on( 'dragStart', function( event, pointer ) {
      document.body.dataset.dragging = true
    });
  }

  initOnDragEnd() {
    this.flkty.on( 'dragEnd', function( event, pointer ) {
      // this is just in case the lightbox does not set it as false
      setTimeout(() => {
        document.body.dataset.dragging = false
      }, 50);
    });
  }
}
