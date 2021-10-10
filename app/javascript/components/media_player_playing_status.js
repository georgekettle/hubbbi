const initMediaPlayerPlayingStatus = () => {
  const mediaPlayerPlaying = document.querySelector('#media-player-playing')
  if (mediaPlayerPlaying) {
    window.addEventListener('mediaPlayer:change', (e) => {
      const isPaused = e.detail.paused
      if (isPaused) {
        mediaPlayerPlaying.classList.add('hidden')
      } else {
        mediaPlayerPlaying.classList.remove('hidden')
      }
    })
  }
}

export { initMediaPlayerPlayingStatus }
