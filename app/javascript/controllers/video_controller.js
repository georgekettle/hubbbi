import { Controller } from "@hotwired/stimulus"
import Plyr from 'plyr';
import tippy from 'tippy.js';

export default class extends Controller {
  static targets = ['title', 'container']
  static values = {
    vimeoHash: String
  }

  initialize() {
    this.chapterTippys = []
    this.player = new Plyr(this.containerTarget, {
      ratio: '16:9',
      captions: {active: true},
      vimeo: { h: this.vimeoHashValue }
    })

    const _this = this
    this.player.on('play', event => {
      _this.hasTitleTarget && _this.titleTarget.classList.add("hidden")
    });

    this.player.on('ready', event => {
      _this.plyrTooltip = _this.element.querySelector('.plyr__tooltip')
      if (_this.player.isVimeo) {
        _this.initVimeoChapters()
      }
    });
  }

  initVimeoChapters() {
    const _this = this
    this.player.embed.getChapters().then(function(chapters) {
        // chapters = an array of chapters objects
        const progressBar = _this.element.querySelector('.plyr__progress')
        const chaptersHTML = _this.createVimeoChapters(chapters)
        progressBar.insertAdjacentHTML('beforeend', chaptersHTML)
        // setup event listeners to hide time tooltip when hover
        const chapterElements = _this.element.querySelectorAll('#chapter')
        chapterElements.forEach((elem) => {
          elem.addEventListener('mouseout', _this.showPlayerTooltip.bind(_this))
          elem.addEventListener('mouseover', _this.hidePlayerTooltip.bind(_this))
          elem.addEventListener('click', (e) => {
            const currentTime = e.currentTarget.dataset.startTime
            _this.player.currentTime = parseInt(currentTime)
          })
        })
    }).catch(function(error) {
        // an error occurred
        console.log(error)
    });
  }

  hidePlayerTooltip(e) {
    this.plyrTooltip.classList.add('hidden')
  }

  showPlayerTooltip(e) {
    this.plyrTooltip.classList.remove('hidden')
  }

  createVimeoChapters(chapters) {
    let html = ''
    chapters.forEach((chapter) => {
      console.log(chapter)
      const position = chapter.startTime / this.player.duration * 100
      html += `<div class="group inline-block relative flex-shrink-0" style="left: ${position}%">
                <span class="plyr__vimeo-chapter group-hover:opacity-100 transform -translate-x-1/2">${chapter.title}</span>
                <div class="relative inline-block pointer-events-auto flex-shrink-0">
                  <div class="rounded-full p-1 pointer-events-auto" id="chapter" data-start-time="${chapter.startTime}">
                    <div class="rounded-full h-1 w-1 bg-white transform group-hover:w-3 group-hover:h-3 duration-100 pointer-events-auto"></div>
                  </div>
                </div>
              </div>`
    })
    html = '<div class="absolute z-10 top-1/2 transform -translate-y-1/2 flex items-center w-full pointer-events-none">' + html + '</div>'
    return html
  }
}
