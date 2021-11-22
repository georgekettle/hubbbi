// A Growl-style alert that slides into view at the top of the screen when rendered,
// and slides back out of view when the "X" button is clicked/pressed.
// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="accordion">
//   <div> <!-- parent must be a div -->
//     <h2>My title</h2>
//     <%= link_to 'title', '#', data: {action: 'accordion#toggle'} %>
//     <div class="hidden" data-accordion-target="source">
//       Text to be toggled
//     </div>
//   </div>
// </div>

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ["source"]

  toggle() {
    (event.target.tagName.toLowerCase() !== 'a') && this.sourceTarget.classList.toggle('hidden')
  }
}
