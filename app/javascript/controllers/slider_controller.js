import { Controller } from "stimulus"
var Flickity = require('flickity');
require('flickity-imagesloaded');

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.initSlider()
  }

  initSlider() {
    var flkty = new Flickity( this.element, {
      // options
      cellAlign: 'left',
      contain: true,
      imagesLoaded: true,
      touchVerticalScroll: false
    });
  }
}
