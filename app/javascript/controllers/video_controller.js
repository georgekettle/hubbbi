import { Controller } from "@hotwired/stimulus"
import Plyr from 'plyr';

export default class extends Controller {
  static targets = ['title', 'container']

  initialize() {
    this.player = new Plyr(this.containerTarget, {
      ratio: '16:9',
      captions: {active: true}
    });

    const _this = this
    this.player.on('play', event => {
      _this.titleTarget.classList.add("hidden")
    });
  }
}
