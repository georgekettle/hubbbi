import { Controller } from "stimulus"
import { Sortable, Plugins } from '@shopify/draggable';

export default class extends Controller {
  static targets = ["container"]

  connect() {
    this.initSortable()
  }

  initSortable() {
    this.sortable = new Sortable(this.containerTarget, {
      draggable: `#sortable-elem`,
      mirror: {
        constrainDimensions: true,
      },
      plugins: [Plugins.ResizeMirror],
    });
  }
}
