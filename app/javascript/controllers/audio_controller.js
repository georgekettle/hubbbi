import { Controller } from "stimulus"

let player // to enable sync of all audio's on the page (ie. pause playing if I play anothe mp3)

export default class extends Controller {
  static targets = ["audio", "play", "pause", "progress", "progressContainer", "duration", "currentTime"]
  static values = { src: String }

  connect() {
    const _this = this
    this.sound = this.audioTarget
    this.audioTarget.addEventListener('timeupdate', (e) => {
      this.updateProgress(e, _this)
    });
    this.sound.addEventListener('durationchange', (e) => {
      _this.setDuration()
    });

  }

  disconnect() {
    this.pause()
  }

  play(e) {
    e && e.preventDefault()
    if (player) {
      player.pause()
    }
    player = this
    player.sound.play()
    this.playTargets.forEach((play) => {
      play.classList.add('hidden')
    })
    this.pauseTargets.forEach((pause) => {
      pause.classList.remove('hidden')
    })
  }

  pause(e) {
    e && e.preventDefault()
    if (player == this) {
      player = null
    }
    this.sound.pause()
    this.playTargets.forEach((play) => {
      play.classList.remove('hidden')
    })
    this.pauseTargets.forEach((pause) => {
      pause.classList.add('hidden')
    })
  }

  setDuration() {
    this.durationTarget.innerHTML = this.secondsToTime(this.sound.duration)
  }

  secondsToTime(e){
    var h = Math.floor(e / 3600).toString().padStart(2,'0'),
        m = Math.floor(e % 3600 / 60).toString().padStart(2,'0'),
        s = Math.floor(e % 60).toString().padStart(2,'0');

    if (parseInt(h) > 0) {
      return h + ':' + m + ':' + s;
    } else {
      return m + ':' + s;
    }
    //return `${h}:${m}:${s}`;
  }

  // Update progress bar
  updateProgress(e, _this) {
    // set progress bar
    const { duration, currentTime } = e.srcElement;
    const progressPercent = (currentTime / duration) * 100;
    _this.progressTarget.style.width = `${progressPercent}%`;
    // set currentTime
    _this.currentTimeTarget.innerText = _this.secondsToTime(currentTime)
  }

  // Set progress bar
  setProgress(e) {
    const width = e.currentTarget.clientWidth;
    const clickX = e.offsetX;
    const duration = this.sound.duration;

    this.sound.currentTime = (clickX / width) * duration;
    if (this.sound.paused) {
      this.pause()
    } else {
      this.play()
    }
  }
}
