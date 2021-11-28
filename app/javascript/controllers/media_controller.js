import { Controller } from "@hotwired/stimulus"
import Plyr from 'plyr';

const updateInterval = 30 // 30s between updates

export default class extends Controller {
  static targets = ["audio", "play", "pause", "next", "progress", "progressContainer", "currentTime", "timeLeft", "ffwd15", "rev15", "floatingMediaPlayer"]
  static values = {
    playing: Boolean,
    url: String,
    groupMemberUrl: String,
    progress: Number
  }

  initialize() {
    this.listenForToggleFloatingMediaPlayer()
  }

  audioTargetConnected(element) {
    this.player = new Plyr(this.audioTarget, {
      hideControls: false
    })
    this.initValues()
    this.initEventListeners()
    this.playingValue && this.player.play()
    this.incomplete = true
  }

  initValues() {
    this.setUrlValue()
    this.setPlayingValue()
    this.setProgressValue()
  }

  setUrlValue() {
    this.urlValue = this.audioTarget.dataset.mediaUrlValue
  }

  setPlayingValue() {
    this.playingValue = this.audioTarget.dataset.mediaPlayingValue
  }

  setProgressValue() {
    this.progressValue = this.audioTarget.dataset.mediaProgressValue
  }

  playingValueChanged(value, previousValue) {
    if (this.hasAudioTarget) {
      this.audioTarget.dataset.mediaPlayingValue = value
    }
    this.dispatchWindowPauseEvent(!value)
  }

  initEventListeners() {
    const _this = this
    // listen to play
    this.player.on('play', (e) => {
      _this.updateControls()
    })
    this.player.on('pause', (e) => {
      _this.updateControls()
    })
    // update progress as song plays
    this.player.on('timeupdate', (e) => {
      // console.log('timeupdate')
      _this.updateProgress()
    });
    // remove loading screen when can play
    this.audioTarget.addEventListener('ready', (e) => {
      _this.setStartingProgress()
    })
    this.player.on('ended', (e) => {
      console.log('ended')
      console.log(this.player.currentTime)
      console.log(this.player.duration)
      debugger
      _this.playNextSong()
    })
    document.addEventListener('turbo:load', () => {
      _this.dispatchWindowPauseEvent(!_this.playingValue)
    });
  }

  updateControls() {
    this.playTargets.forEach((play) => {
      this.player.paused && play.classList.remove('hidden')
      !this.player.paused && play.classList.add('hidden')
    })
    this.pauseTargets.forEach((pause) => {
      this.player.paused && pause.classList.add('hidden')
      !this.player.paused && pause.classList.remove('hidden')
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

  setStartingProgress() {
    const currentTime = this.player.duration * (this.progressValue / 100)
    if (isFinite(currentTime)) {
      this.player.currentTime = currentTime
    }
    this.lastSavedTime = currentTime
    this.updateProgress()
  }

  // Update progress bar
  updateProgress() {
    // set progress bar
    const _this = this
    const progressPercent = (this.player.currentTime / this.player.duration) * 100
    const timeLeft = this.player.duration - this.player.currentTime
    // set progress percent
    this.progressTargets.forEach((progress) => {
      progress.style.width = `${progressPercent}%`
    })
    // set currentTime
    this.currentTimeTargets.forEach((currentTimeTarget) => {
      currentTimeTarget.innerText = this.secondsToTime(this.player.currentTime)
    })
    // set timeLeft
    this.timeLeftTargets.forEach((timeLeftTarget) => {
      timeLeftTarget.innerText = '-' + _this.secondsToTime(timeLeft)
    })
    // update media play if complete or more than 30s diff
    if (this.player.currentTime != 100 && (Math.abs(this.player.currentTime - this.lastSavedTime)) > updateInterval) {
      this.lastSavedTime = this.player.currentTime
      const body = { "media_play": { "progress": progressPercent } }
      this.updateProgressRequest(body)
    }
  }

  // Set progress bar
  setProgress(e) {
    e.preventDefault()
    const width = e.currentTarget.clientWidth
    const clickX = e.offsetX
    // set currentTime
    if (width > 0) {
      this.player.currentTime = (clickX / width) * this.player.duration
    }
    if (this.player.paused) {
      this.pause()
    } else {
      this.play()
    }
  }

  play(e) {
    e && e.preventDefault()
    this.player.play()
    this.playingValue = true
    this.updateControls()
  }

  pause(e) {
    e && e.preventDefault()
    this.player.pause()
    this.playingValue = false
    this.updateControls()
  }

  ffwd15(e) {
    e.preventDefault()
    this.player.currentTime += 15
  }

  rev15(e) {
    e.preventDefault()
    const startOfSong = this.player.currentTime === 0
    if (!startOfSong) {
      this.player.currentTime = this.player.currentTime -= 15
    }
  }

  updateProgressRequest(body) {
    const CSRFToken = document.querySelector('meta[name="csrf-token"]').content

    fetch(this.urlValue, {
      method: 'PATCH',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': CSRFToken,
      },
      body: JSON.stringify(body),
    })
  }

  playNextSong() {
    const body = { "media_play": { "progress": 100, "complete": true } }
    this.updateProgressRequest(body)
    this.incomplete = false
    this.nextTargets[0].click()
  }

  dispatchWindowPauseEvent(status) {
    // dispatch event (is paused) => so that media_player_toggle.html.erb can register changes
    const pauseEvent = new CustomEvent('mediaPlayer:change', { detail: { paused: status } })
    window.dispatchEvent(pauseEvent)
  }

  listenForToggleFloatingMediaPlayer() {
    const _this = this
    window.addEventListener('toggleFloatingMediaPlayer', (e) => {
      e.preventDefault()
      const CSRFToken = document.querySelector('meta[name="csrf-token"]').content
      _this.floatingMediaPlayerTarget.classList.toggle('hidden')
      const isHidden = _this.floatingMediaPlayerTarget.classList.contains('hidden')
      const body = {'group_member': {
        'hide_media_player': isHidden
      }}
      fetch(_this.groupMemberUrlValue, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': CSRFToken,
        },
        body: JSON.stringify(body),
      })
    })
  }
}
