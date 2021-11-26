import { Controller } from "@hotwired/stimulus"
import Plyr from 'plyr';

const updateInterval = 30 // 30s between updates

export default class extends Controller {
  static targets = ["audio", "play", "pause", "next", "progress", "progressContainer", "currentTime", "timeLeft", "ffwd15", "rev15", "mediaControlsContainer", "mediaControlsContainerLoading", "floatingMediaPlayer"]
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
    this.player = new Plyr(this.audioTarget)
    this.sound = this.audioTarget
    this.sound.readyState >= 2 && this.prepareControls()
    this.initValues()
    this.initEventListeners()
    this.playingValue && this.sound.play()
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

  prepareControls() {
    this.updateProgress()
    this.dismissLoadingControls()
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
      // console.log('timeupdate')
      _this.updateProgress()
    });
    // remove loading screen when can play
    this.audioTarget.addEventListener('ready', (e) => {
      _this.prepareControls()
    })
    this.sound.addEventListener('durationchange', (e) => {
      // console.log('durationchange')
      _this.setStartingProgress()
    })
    this.sound.addEventListener('ended', (e) => {
      _this.playNextSong()
    })
    document.addEventListener('turbo:load', () => {
      _this.dispatchWindowPauseEvent(!_this.playingValue)
    });
  }

  dismissLoadingControls() {
    this.mediaControlsContainerLoadingTargets.forEach((loadingTarget) => {
      loadingTarget.classList.add('hidden')
    })
    this.mediaControlsContainerTargets.forEach((mediaContainerTarget) => {
      mediaContainerTarget.classList.remove('hidden')
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

  setStartingProgress() {
    const currentTime = this.sound.duration * (this.progressValue / 100)
    if (isFinite(currentTime)) {
      this.sound.currentTime = currentTime
    }
    this.lastSavedTime = currentTime
  }

  // Update progress bar
  updateProgress() {
    // set progress bar
    const _this = this
    const { duration, currentTime } = this.sound
    const progressPercent = (currentTime / duration) * 100
    const timeLeft = duration - currentTime
    // set progress percent
    this.progressTargets.forEach((progress) => {
      progress.style.width = `${progressPercent}%`
    })
    // set currentTime
    this.currentTimeTargets.forEach((currentTimeTarget) => {
      currentTimeTarget.innerText = this.secondsToTime(currentTime)
    })
    // set timeLeft
    this.timeLeftTargets.forEach((timeLeftTarget) => {
      timeLeftTarget.innerText = '-' + _this.secondsToTime(timeLeft)
    })
    // update media play if complete or more than 30s diff
    if (currentTime != 100 && (Math.abs(currentTime - this.lastSavedTime)) > updateInterval) {
      this.lastSavedTime = currentTime
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
      this.sound.currentTime = (clickX / width) * this.sound.duration
    }
    if (this.sound.paused) {
      this.pause()
    } else {
      this.play()
    }
  }

  play(e) {
    e && e.preventDefault()
    this.sound.play()
    this.playingValue = true
    this.updateControls()
  }

  pause(e) {
    e && e.preventDefault()
    this.sound.pause()
    this.playingValue = false
    this.updateControls()
  }

  ffwd15(e) {
    e.preventDefault()
    this.sound.currentTime += 15
    if (this.sound.currentTime === this.sound.duration && this.incomplete) {
      this.updateProgress()
      this.playNextSong()
    }
  }

  rev15(e) {
    e.preventDefault()
    const startOfSong = this.sound.currentTime === 0
    if (!startOfSong) {
      this.sound.currentTime = this.sound.currentTime -= 15
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
