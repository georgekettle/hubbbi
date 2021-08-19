import { Controller } from "stimulus"
import * as Choices from "choices.js"

export default class extends Controller {
  initialize() {
    this.choices = this.initChoices()
  }

  initChoices() {
    const choices = new Choices(this.element, {
      silent: false,
      items: [],
      choices: [],
      removeItems: true,
      removeItemButton: true,
      searchResultLimit: 10,
      duplicateItemsAllowed: false,
      editItems: true,
      placeholder: true,
      placeholderValue: "Add tags",
      searchPlaceholderValue: "Add tags",
      renderSelectedChoices: 'auto',
      loadingText: 'Loading...',
      noResultsText: 'No results found',
      noChoicesText: 'No choices to choose from',
      itemSelectText: 'Press to select',
      addItemText: (value) => {
        return `Press Enter to add <b>"${value}"</b>`;
      },
      maxItemText: (maxItemCount) => {
        return `Only ${maxItemCount} values can be added`;
      },
      valueComparer: (value1, value2) => {
        return value1.toLowerCase() === value2.toLowerCase();
      }
    });

    return choices
  }
}
