import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    playing: Boolean
  }

  connect() {
    this.initTargets() // necessary due to html complications and seperated element with modal and floating element
    this.sound = this.element
    this.initEventListeners()
    this.playingValue && this.sound.play()
  }

  initTargets() {
    const targets = ["play", "pause", "progress", "progressContainer", "currentTime", "timeLeft", "ffwd15", "rev15"]
    targets.forEach((targetName) => {
      this[`${targetName}Targets`] = document.querySelectorAll(`[data-media-target="${targetName}"]`)
    })
  }

  initEventListeners() {
    const _this = this
    // listen to play
    this.sound.addEventListener('play', (e) => {
      _this.updateControls()
    })
    this.sound.addEventListener('pause', (e) => {
      _this.updateControls()
    })
    // update progress as song plays
    this.sound.addEventListener('timeupdate', (e) => {
      _this.updateProgress(e)
    });
    // setup play
    this.playTargets.forEach((playTarget) => {
      playTarget.addEventListener('click', (e) => {
        _this.play(e)
      })
    })
    // setup pause
    this.pauseTargets.forEach((pauseTarget) => {
      pauseTarget.addEventListener('click', (e) => {
        _this.pause(e)
      })
    })
    // setup click on progress bar
    this.progressContainerTargets.forEach((progressContainerTarget) => {
      progressContainerTarget.addEventListener('click', (e) => {
        _this.setProgress(e)
      })
    })
    // setup ffwd15 click event
    this.ffwd15Targets.forEach((ffwd15Target) => {
      ffwd15Target.addEventListener('click', (e) => {
        _this.ffwd15(e)
      })
    })
    // setup rev15 click event
    this.rev15Targets.forEach((rev15Target) => {
      rev15Target.addEventListener('click', (e) => {
        _this.rev15(e)
      })
    })
  }

  updateControls() {
    this.playTargets.forEach((play) => {
      this.sound.paused && play.classList.remove('hidden')
      !this.sound.paused && play.classList.add('hidden')
    })
    this.pauseTargets.forEach((pause) => {
      this.sound.paused && pause.classList.add('hidden')
      !this.sound.paused && pause.classList.remove('hidden')
    })
  }

  secondsToTime(e){
    var h = Math.floor(e / 3600).toString().padStart(2,'0'),
        m = Math.floor(e % 3600 / 60).toString(),
        s = Math.floor(e % 60).toString().padStart(2,'0');

    if (parseInt(h) > 0) {
      return h + ':' + m + ':' + s;
    } else if (parseInt(m) > 9) {
      return m.padStart(2,'0') + ':' + s;
    } else {
      return m + ':' + s;
    }
  }

  // Update progress bar
  updateProgress(e) {
    // set progress bar
    const { duration, currentTime } = e.srcElement
    const progressPercent = (currentTime / duration) * 100
    const timeLeft = duration - currentTime
    this.progressTargets.forEach((progress) => {
      progress.style.width = `${progressPercent}%`
    })
    // set currentTime
    this.currentTimeTargets.forEach((currentTimeTarget) => {
      currentTimeTarget.innerText = this.secondsToTime(currentTime)
    })
    // set timeLeft
    this.timeLeftTargets.forEach((timeLeftTarget) => {
      timeLeftTarget.innerText = '-' + this.secondsToTime(timeLeft)
    })
  }

  // Set progress bar
  setProgress(e) {
    e.preventDefault()
    const width = e.currentTarget.clientWidth
    const clickX = e.offsetX
    // set currentTime
    this.sound.currentTime = (clickX / width) * this.sound.duration
    if (this.sound.paused) {
      this.pause()
    } else {
      this.play()
    }
  }

  play(e) {
    e.preventDefault()
    this.sound.play()
    this.updateControls()
  }

  pause(e) {
    e.preventDefault()
    this.sound.pause()
    this.updateControls()
  }

  ffwd15(e) {
    e.preventDefault()
    this.sound.currentTime = this.sound.currentTime + 15
  }

  rev15(e) {
    e.preventDefault()
    this.sound.currentTime = this.sound.currentTime - 15
  }
}
