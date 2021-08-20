import { Controller } from "stimulus"
import Isotope from "isotope-layout"

export default class extends Controller {
  static targets = ["container", "toggle"]

  initialize() {
    this.hasContainerTarget && this.initFilter();
    this.activeFilters = []
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
    this.iso.arrange({
      // item element provided as argument
      filter: '*'
    });
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
    // toggleButton.classList.add('active')
    // const toggleButtonFilters = JSON.parse(toggleButton.dataset.filters)
    // this.iso.arrange({
    //   // item element provided as argument
    //   filter: function( itemElem ) {
    //     const itemFilters = JSON.parse(itemElem.dataset.filters)
    //     const intersection = toggleButtonFilters.filter(x => itemFilters.includes(x))
    //     return intersection.length
    //   }
    // });
  }
}
