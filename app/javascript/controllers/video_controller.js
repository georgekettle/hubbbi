import { Controller } from "@hotwired/stimulus"
import Plyr from 'plyr';
import tippy from 'tippy.js';

export default class extends Controller {
  static targets = ['title', 'container', 'chapter']
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
        _this.player.embed.getChapters().then(function(chapters) {
            // chapters = an array of chapters objects
            const progressBar = _this.element.querySelector('.plyr__progress')
            const chaptersHTML = _this.createVimeoChapters(chapters)
            progressBar.insertAdjacentHTML('beforeend', chaptersHTML)
        }).catch(function(error) {
            // an error occurred
            console.log(error)
        });
      }
    });
  }

  chapterTargetConnected(element) {
    const _this = this
    const chapter = JSON.parse(element.dataset.chapter)
    const chapterTippy = tippy(element, {
      content: chapter.title,
      arrow: true,
      onShow(instance) {
        _this.plyrTooltip.classList.add('hidden')
      },
      onHide(instance) {
        _this.plyrTooltip.classList.remove('hidden')
      },
    });
    this.chapterTippys.push(chapterTippy)
  }

  chapterTargetDisconnected(element) {
    this.chapterTippys.forEach((tippyElement) => {
      tippyElement.destroy()
    })
  }

  createVimeoChapters(chapters) {
    let html = ''
    chapters.forEach((chapter) => {
      const position = chapter.startTime / this.player.duration * 100
      html += `<div class="relative inline-block pointer-events-auto flex-shrink-0" style="left: ${position}%" id="chapter" data-video-target="chapter" data-chapter='${JSON.stringify(chapter)}'>
            <div class="group rounded-full p-1 pointer-events-auto">
              <div class="rounded-full h-1 w-1 bg-white transform group-hover:w-3 group-hover:h-3 duration-100 pointer-events-auto"></div>
            </div>
          </div>`
    })
    html = '<div class="absolute z-10 top-1/2 transform -translate-y-1/2 flex items-center w-full pointer-events-none">' + html + '</div>'
    return html
  }
}
