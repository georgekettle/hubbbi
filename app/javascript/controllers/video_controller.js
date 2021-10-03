import { Controller } from "@hotwired/stimulus"
import Plyr from 'plyr';

export default class extends Controller {
  initialize() {
    this.player = new Plyr(this.element, {
      ratio: '4:3',
      captions: {active: true}
    });
  }
}
