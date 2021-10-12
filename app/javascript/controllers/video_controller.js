import { Controller } from "@hotwired/stimulus"
import Plyr from 'plyr';

export default class extends Controller {
  static targets = ['title', 'container']
  static values = {
    vimeoHash: String
  }

  initialize() {
    this.player = new Plyr(this.containerTarget, {
      ratio: '16:9',
      captions: {active: true},
      vimeo: { h: this.vimeoHashValue }
    })

    const _this = this
    this.player.on('play', event => {
      _this.hasTitleTarget && _this.titleTarget.classList.add("hidden")
    });
  }
}
