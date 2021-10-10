const initMediaPlayerPlayingStatus = () => {
  const mediaPlayerToggle = document.querySelector('#media-player-toggle')
  if (mediaPlayerToggle) {
    window.addEventListener('mediaPlayer:change', (e) => {
      const isPaused = e.detail.paused
      if (isPaused) {
        mediaPlayerToggle.classList.remove('playing')
      } else {
        mediaPlayerToggle.classList.add('playing')
      }
    })
  }
}

export { initMediaPlayerPlayingStatus }
