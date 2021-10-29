import { Controller } from "@hotwired/stimulus"
import Plyr from 'plyr';

export default class extends Controller {
  static targets = ['title', 'container']
  static values = {
    vimeoHash: String
  }

  initialize() {
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
      _this.player.isVimeo && _this.initVimeoChapters()
    });

    this.player.on('controlshidden', event => {
      _this.chaptersTarget.classList.add('hidden')
    });

    this.player.on('controlsshown', event => {
      _this.chaptersTarget.classList.remove('hidden')
    });
  }

  initVimeoChapters() {
    const _this = this
    this.player.embed.getChapters().then(function(chapters) {
        // chapters = an array of chapters objects
        const chaptersHTML = _this.createVimeoChapters(chapters)
        _this.containerTarget.insertAdjacentHTML('beforeend', chaptersHTML)
        _this.chaptersTarget = _this.element.querySelector('#chapters')
        // setup event listeners to hide time tooltip when hover
        const chapterElements = _this.element.querySelectorAll('#chapter')
        chapterElements.forEach((elem) => {
          elem.addEventListener('click', (e) => {
            e.preventDefault()
            const currentTime = e.currentTarget.dataset.startTime
            _this.player.currentTime = parseInt(currentTime)
          })
        })
    }).catch(function(error) {
        // an error occurred
        console.log(error)
    });
  }

  createVimeoChapters(chapters) {
    let html = ''
    if (chapters.length === 0) {
      return html
    }

    chapters.forEach((chapter) => {
      const time = (chapter.startTime < 3600) ? new Date(chapter.startTime * 1000).toISOString().substr(14, 5) : new Date(chapter.startTime * 1000).toISOString().substr(11, 8);
      html += `<a href="#" id="chapter" class="dropdown-link flex justify-between items-center leading-tight" data-start-time="${chapter.startTime}">
                <span class="line-clamp-3">${chapter.title}</span>
                <span class="text-xs text-gray-400 flex-shrink-0">${time}</span>
              </a>`
    })
    return `<div id="chapters" class="hidden z-10 group absolute top-2 right-2 sm:top-4 sm:right-4">
              <div class="relative">
                <div class="flex justify-end pb-1">
                  <div class="backdrop-filter backdrop-blur bg-black bg-opacity-50 py-1.5 px-3 pb-2 rounded flex items-center text-white border border-white text-sm">
                    <svg class="stroke-current h-3 w-3 mr-2" width="18px" height="18px" viewBox="0 0 18 18" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
                        <g id="Page-1" stroke-width="1" fill="none" fill-rule="evenodd">
                            <g id="Interface,-Essential/List,-Numbers" transform="translate(-3.000000, -3.000000)">
                                <g id="Group" transform="translate(-0.000000, -0.000000)">
                                    <g stroke-linecap="round" stroke-linejoin="round" transform="translate(4.000000, 3.000000)" id="Path" stroke-width="1.5">
                                        <path d="M7.00000003,1 L16.0000001,1"></path>
                                        <path d="M7.15000003,6.00000003 L16.0000001,6.00000003"></path>
                                        <polyline points="2.50000001 6.00000003 0 6.00000003 1.25000001 6.00000003 1.25000001 1 0 2.25000001"></polyline>
                                        <path d="M7.00000003,12.0000001 L16.0000001,12.0000001"></path>
                                        <path d="M7.15000003,17.0000001 L16.0000001,17.0000001"></path>
                                        <polyline points="0 12.0000001 2.50000001 12.0000001 2.50000001 14.0000001 0 15.5000001 0 17.0000001 2.75000001 17.0000001"></polyline>
                                    </g>
                                    <polygon stroke="none" id="Path" points="0 0 24.0000001 0 24.0000001 24.0000001 0 24.0000001"></polygon>
                                </g>
                            </g>
                        </g>
                    </svg>
                    Chapters
                  </div>
                </div>
                <div class="hidden group-hover:block absolute top-full right-0 w-56 max-h-32 rounded shadow-lg bg-white border border-gray-200 focus:outline-none overflow-x-hidden overflow-y-scroll">
                  ${html}
                </div>
              </div>
            </div>`
  }
}
