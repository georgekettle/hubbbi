// <div data-controller="tabs" data-tabs-active-tab="-mb-px border-l border-t border-r rounded-t">
//   <ul class="list-reset flex border-b">
//     <li class="-mb-px mr-1" data-tabs-target="tab" data-action="click->tabs#change">
//       <a class="bg-white inline-block py-2 px-4 text-blue-500 hover:text-blue-700 font-semibold no-underline" href="#">Active</a>
//     </li>
//     <li class="mr-1" data-tabs-target="tab" data-action="click->tabs#change">
//       <a class="bg-white inline-block py-2 px-4 text-blue-500 hover:text-blue-700 font-semibold no-underline" href="#">Tab</a>
//     </li>
//     <li class="mr-1" data-tabs-target="tab" data-action="click->tabs#change">
//       <a class="bg-white inline-block py-2 px-4 text-blue-500 hover:text-blue-700 font-semibold no-underline" href="#">Tab</a>
//     </li>
//     <li class="mr-1">
//       <a class="bg-white inline-block py-2 px-4 text-gray-300 font-semibold no-underline" href="#">Tab</a>
//     </li>
//   </ul>

//   <div class="hidden py-4 px-4 border-l border-b border-r" data-tabs-target="panel">
//     Tab panel 1
//   </div>

//   <div class="hidden py-4 px-4 border-l border-b border-r" data-tabs-target="panel">
//     Tab panel 2
//   </div>

//   <div class="hidden py-4 px-4 border-l border-b border-r" data-tabs-target="panel">
//     <iframe width="560" height="315" src="https://www.youtube.com/embed/y3niFzo5VLI" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>
//   </div>
// </div>

import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['tab', 'panel']
  static values = {
    url: String,
    method: { type: String, default: 'GET' },
  }

  connect() {
    this.activeTabClasses = (this.data.get('activeTab') || 'active').split(' ')
    this.inactiveTabClasses = (this.data.get('inactiveTab') || 'inactive').split(' ')
    if (this.anchor) this.index = this.tabTargets.findIndex((tab) => tab.id === this.anchor)
    this.showTab()
  }

  change(event) {
    event.preventDefault()

    // If target specifies an index, use that
    if (event.currentTarget.dataset.index) {
      this.index = event.currentTarget.dataset.index

    // If target specifies an id, use that
    } else if (event.currentTarget.dataset.id) {
      this.index = this.tabTargets.findIndex((tab) => tab.id == event.currentTarget.dataset.id)

    // Otherwise, use the index of the current target
    } else {
      this.index = this.tabTargets.indexOf(event.currentTarget)
    }

    window.dispatchEvent(new CustomEvent('tsc:tab-change'))

    if (this.hasUrlValue && typeof this.index === 'number') {
      this.sendRequest()
    }
  }

  showTab() {
    this.tabTargets.forEach((tab, index) => {
      const panel = this.panelTargets[index]

      if (index === this.index) {
        panel.classList.remove('hidden')
        tab.classList.remove(...this.inactiveTabClasses)
        tab.classList.add(...this.activeTabClasses)

        // Update URL with the tab ID if it has one
        // This will be automatically selected on page load
        if (tab.id) {
          location.hash = tab.id
        }
      } else {
        panel.classList.add('hidden')
        tab.classList.remove(...this.activeTabClasses)
        tab.classList.add(...this.inactiveTabClasses)
      }
    })
  }

  get index() {
    return parseInt(this.data.get('index') || 0)
  }

  set index(value) {
    this.data.set('index', (value >= 0 ? value : 0))
    this.showTab()
  }

  get anchor() {
    return (document.URL.split('#').length > 1) ? document.URL.split('#')[1] : null;
  }

  sendRequest() {
    let CSRFToken = document.querySelector('meta[name="csrf-token"]').content
    const selectedTab = this.tabTargets[this.index]
    const body = JSON.parse(selectedTab.dataset.requestBody)
    fetch(this.urlValue, {
      method: this.methodValue,
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': CSRFToken
      },
      body: JSON.stringify(body)
    })
    .then(response => response.json())
    .then(data => console.log(data))
    .catch(err => console.log(err))

  }
}
