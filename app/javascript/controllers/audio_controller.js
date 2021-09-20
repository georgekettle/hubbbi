import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["audio", "play", "pause", "progress", "progressContainer", "duration", "currentTime", "timeLeft"]
  static values = {
    src: String,
    playing: Boolean
  }

  connect() {
    const _this = this
    this.sound = this.audioTarget
    this.audioTarget.addEventListener('timeupdate', (e) => {
      this.updateProgress(e, _this)
    });
    this.sound.addEventListener('durationchange', (e) => {
      _this.setDuration()
    });
    this.playingValue && this.play()
  }

  disconnect() {
    this.pause()
  }

  play(e) {
    e && e.preventDefault()
    this.sound.play()
    this.playTargets.forEach((play) => {
      play.classList.add('hidden')
    })
    this.pauseTargets.forEach((pause) => {
      pause.classList.remove('hidden')
    })
  }

  pause(e) {
    e && e.preventDefault()
    this.sound.pause()
    this.playTargets.forEach((play) => {
      play.classList.remove('hidden')
    })
    this.pauseTargets.forEach((pause) => {
      pause.classList.add('hidden')
    })
  }

  setDuration() {
    this.durationTargets.forEach((duration) => {
      duration.innerHTML = this.secondsToTime(this.sound.duration)
    })
    this.timeLeftTargets.forEach((timeLeft) => {
      timeLeft.innerHTML = '-' + this.secondsToTime(this.sound.duration)
    })
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
    const { duration, currentTime } = e.srcElement
    const progressPercent = (currentTime / duration) * 100
    const timeLeft = duration - currentTime
    _this.progressTargets.forEach((progress) => {
      progress.style.width = `${progressPercent}%`
    })
    // set currentTime
    _this.currentTimeTargets.forEach((currentTimeTarget) => {
      currentTimeTarget.innerText = _this.secondsToTime(currentTime)
    })
    // set timeLeft
    _this.timeLeftTargets.forEach((timeLeftTarget) => {
      timeLeftTarget.innerText = '-' + _this.secondsToTime(timeLeft)
    })
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
