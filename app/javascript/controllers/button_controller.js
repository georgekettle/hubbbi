import { Controller } from "@hotwired/stimulus"

const savingIcon = `<svg class="animate-spin stroke-current" width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g id="Page-1" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Interface,-Essential/Rotate,-Refresh,-Loading-Copy" transform="translate(-2.000000, -2.000000)">
            <g id="Group" transform="translate(12.000000, 12.000000) scale(-1, 1) translate(-12.000000, -12.000000) translate(-0.000000, -0.000000)">
                <g>
                    <rect id="Rectangle" x="0" y="0" width="24.0000001" height="24.0000001"></rect>
                    <polyline id="Path" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" points="6.75000003 8.25000003 3.00000001 8.25000003 3.00000001 4.50000002"></polyline>
                    <path d="M21.0000001,12.0000001 C21.0000001,7.02900003 16.9710001,3.00000001 12.0000001,3.00000001 C8.37000003,3.00000001 5.24900002,5.15400002 3.82600002,8.25000003" id="Path" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                    <polyline id="Path" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" points="17.2500001 15.7500001 21.0000001 15.7500001 21.0000001 19.5000001"></polyline>
                    <path d="M3.00000001,12.0000001 C3.00000001,16.9710001 7.02900003,21.0000001 12.0000001,21.0000001 C15.6300001,21.0000001 18.7510001,18.8460001 20.1740001,15.7500001" id="Path" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                    <rect id="Rectangle" x="0" y="0" width="24.0000001" height="24.0000001"></rect>
                </g>
            </g>
        </g>
    </g>
</svg>`

export default class extends Controller {
  static values = {
    loader: {
      type: String,
      default: savingIcon
    }
  }

  showLoader(e) {
    this.element.innerHTML = this.loaderValue
  }
}
