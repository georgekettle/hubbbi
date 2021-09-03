import { Controller } from "stimulus"
import lightGallery from '../components/light_gallery/light_gallery'
// import lgVideo from '../components/light_gallery/lg_video'
import lgVideo from 'lightgallery/plugins/video'

export default class extends Controller {
  static targets = ["gallery", "item"]

  connect() {
    this.initCloseButton()
    this.initDownloadButton()
    this.initLightGallery()
    this.initPreventOpenOnDrag()
    this.moved = false
  }

  initLightGallery() {
    this.lg = lightGallery(this.galleryTarget, {
        selector: ".gallery-item",
        speed: 500,
        videojs: true,
        videojsOptions: {
            muted: true,
        },
        plugins: [lgVideo],
        container: document.body,
        nextHtml: this.nextHTML(),
        prevHtml: this.prevHTML()
    })
  }

  initPreventOpenOnDrag() {
    const self = this
    this.galleryTarget.addEventListener('lgBeforeOpen', (e) => {
      if (document.body.dataset.dragging === "true") {
        self.lg.lgOpened = true

        setTimeout(() => {
          self.lg.lgOpened = false
          document.body.dataset.dragging = false
        }, 5);
      }
    })
  }

  initDownloadButton() {
    const controller = this
    this.galleryTarget.addEventListener("lgBeforeOpen", (e) => {
      const lgDownloadIcon = document.querySelector(`#lg-download-${controller.lg.lgId}`);
      if (lgDownloadIcon) {lgDownloadIcon.innerHTML = controller.downloadHTML()}
    });
  }

  initCloseButton() {
    const controller = this
    this.galleryTarget.addEventListener("lgBeforeOpen", (e) => {
      const lgCloseIcon = document.querySelector(`#lg-close-${controller.lg.lgId}`);
      if (lgCloseIcon) {lgCloseIcon.innerHTML = controller.closeHTML()}
    });
  }

  downloadHTML() {
    return `<svg class="stroke-current text-white" width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
          <g id="Page-1" stroke-width="1" fill="none" fill-rule="evenodd">
              <g id="Interface,-Essential/Download,-Save,-Circle" transform="translate(-2.000000, -2.000000)">
                  <g id="Group" transform="translate(-0.000000, -0.000000)">
                      <g id="Path">
                          <polygon stroke="none" points="24.0000001 24.0000001 0 24.0000001 0 0 24.0000001 0"></polygon>
                          <path d="M12.0000001,14.0000001 L12.0000001,7.00000003" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                          <polyline stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" points="15.0000001 11 12.0000001 14.0000001 9.00000004 11"></polyline>
                          <path d="M9.00000004,17.0000001 L15.0000001,17.0000001" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                          <path d="M18.3640001,5.63604002 C21.8787201,9.15076004 21.8787201,14.8492401 18.3640001,18.3639401 C14.8492801,21.8786601 9.15080004,21.8786601 5.63610002,18.3639401 C2.12138001,14.8492201 2.12138001,9.15074004 5.63610002,5.63604002 C9.15082004,2.12132001 14.8493001,2.12132001 18.3640001,5.63604002" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                      </g>
                  </g>
              </g>
          </g>
      </svg>`
  }

  closeHTML() {
    return `<svg class="stroke-current text-white" width="10px" height="10px" viewBox="0 0 10 10" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
          <g id="Page-1" stroke-width="1" fill="none" fill-rule="evenodd">
              <g id="Interface,-Essential/Delete,-Disabled" transform="translate(-7.000000, -7.000000)">
                  <g id="Group" transform="translate(-0.000000, -0.000000)">
                      <g id="Path">
                          <path d="M8.00000003,8.00000003 L16.0000001,16.0000001" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                          <path d="M16.0000001,8.00000003 L8.00000003,16.0000001" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                      </g>
                  </g>
              </g>
          </g>
      </svg>`
  }

  nextHTML() {
    return `<div>
        <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-arrow-narrow-right stroke-current text-white" width="22" height="22" viewBox="0 0 24 24" stroke-width="2" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
          <line x1="5" y1="12" x2="19" y2="12" />
          <line x1="15" y1="16" x2="19" y2="12" />
          <line x1="15" y1="8" x2="19" y2="12" />
        </svg>
      </div>`
  }

  prevHTML() {
    return `<div>
        <svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-arrow-narrow-left stroke-current text-white" width="22px" height="22px" viewBox="0 0 22 22" stroke-width="2" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round">
          <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
          <line x1="5" y1="12" x2="19" y2="12" />
          <line x1="5" y1="12" x2="9" y2="16" />
          <line x1="5" y1="12" x2="9" y2="8" />
        </svg>
      </div>`
  }
}
