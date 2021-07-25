import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["search", "container"]

  initialize() {
    this.hasSearchTarget && this.initSearch();
  }

  initSearch() {
    this.searchTarget.addEventListener('keyup', (e) => {
      let query = e.currentTarget.value.toLowerCase();
      this.applyFilter(query);
    })
  }

  applyFilter(query) {
    const childDivs = Array.from(this.containerTarget.children).filter(elem => elem.tagName === 'DIV')
    childDivs.forEach((elem) => {
      var elemText = elem.dataset.filterText;
      if (elemText) {
        this.isQueryMatch(elemText, query) && this.showElement(elem)
        !this.isQueryMatch(elemText, query) && this.hideElement(elem)
      }
    })
  }

  isQueryMatch(text, query) {
    return text.toLowerCase().indexOf(query) !== -1
  }


  showElement(elem) {
    if (elem.classList.contains('fadeOutShrink')) {
      elem.classList.add('animated','fadeInExpand');
      elem.classList.remove('fadeOutShrink');
    }
  }

  hideElement(elem) {
    elem.classList.add('animated','fadeOutShrink');
    elem.classList.remove('fadeInExpand');
  }
}
