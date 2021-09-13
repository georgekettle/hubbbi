import { Controller } from "stimulus"
import {Howl, Howler} from 'howler';

export default class extends Controller {
  static targets = ["play", "pause"]
  static values = { src: String }

  connect() {
    this.sound = new Howl({
      src: [this.srcValue],
      html5: true,
      format: ['mp3', 'aac']
    });
    this.duration = this.sound._duration
  }

  togglePlay(e) {
    e.preventDefault()
    this.sound.playing() ? this.pause() : this.play();
  }

  play() {
    this.sound.play()
    this.playTargets.forEach((play) => {
      play.classList.add('hidden')
    })
    this.pauseTargets.forEach((pause) => {
      pause.classList.remove('hidden')
    })
  }

  pause() {
    this.sound.pause()
    this.playTargets.forEach((play) => {
      play.classList.remove('hidden')
    })
    this.pauseTargets.forEach((pause) => {
      pause.classList.add('hidden')
    })
  }
}
