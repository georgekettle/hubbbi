import { Controller } from "@hotwired/stimulus"
import Isotope from "isotope-layout"

export default class extends Controller {
  static targets = ["container", "toggle", 'showMoreContainer']
  static values = { showCount: Number }

  initialize() {
    this.hasContainerTarget && this.initFilter()
    this.activeFilters = []
    this.extrasHidden = true
    this.showCountValue && this.hideExtras()
  }

  initFilter() {
    this.iso = new Isotope(this.containerTarget, {
      itemSelector: '#filter-item',
      masonry: {
        columnWidth: 0
      }
    });
  }

  removeFilters() {
    if (this.extrasHidden) {
      this.hideExtras()
    } else {
      this.iso.arrange({
        // item element provided as argument
        filter: '*'
      })
    }
  }

  applyFilters(e) {
    const activeFilters = this.activeFilters
    if (activeFilters.length > 0) {
      this.iso.arrange({
        // item element provided as argument
        filter: function( itemElem ) {
          const itemFilters = JSON.parse(itemElem.dataset.filters)
          const intersection = activeFilters.filter(x => itemFilters.includes(x))
          return intersection.length
        }
      });
    } else {
      this.removeFilters()
    }
  }

  addFilter(button) {
    button.classList.add('active')
    const buttonFilters = JSON.parse(button.dataset.filters)
    this.activeFilters = [].concat(this.activeFilters, buttonFilters)
  }

  removeFilter(button) {
    button.classList.remove('active')
    const buttonFilters = JSON.parse(button.dataset.filters)
    this.activeFilters = this.activeFilters.filter(x => !buttonFilters.includes(x))
  }

  toggleFilter(e) {
    const toggleButton = e.currentTarget
    if (toggleButton.classList.contains('active')) {
      this.removeFilter(toggleButton)
    } else {
      this.addFilter(toggleButton)
    }

    this.applyFilters()
  }

  hideExtras() {
    this.extrasHidden = true
    if (this.hasShowMoreContainerTarget) {
      this.showMoreContainerTarget.classList.remove('active')
    }
    this.iso.arrange({
      // item element provided as argument
      filter: ':not(.initially-hidden)'
    });
  }

  showExtras() {
    this.extrasHidden = false
    if (this.hasShowMoreContainerTarget) {
      this.showMoreContainerTarget.classList.add('active')
    }
    this.iso.arrange({
      // item element provided as argument
      filter: '*'
    })
  }

  toggleExtras() {
    if (this.extrasHidden) {
      this.showExtras()
    } else {
      this.hideExtras()
    }
  }
}
