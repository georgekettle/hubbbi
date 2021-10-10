const initMediaPlayerPlayingStatus = () => {
  window.addEventListener('mediaPlayer:change', (e) => {
    const mediaPlayerToggle = document.querySelector('#media_player_toggle')
    const isPaused = e.detail.paused
    if (mediaPlayerToggle) {
      if (isPaused) {
        mediaPlayerToggle.classList.remove('playing')
      } else {
        mediaPlayerToggle.classList.add('playing')
      }
    }
  })
}

export { initMediaPlayerPlayingStatus }
