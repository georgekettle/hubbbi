import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['container', 'pageNum', 'pageCount']
  static values = {
    url: String
  }

  connect() {
    this.hasUrlValue && this.displayPdf()
  }

  disconnect() {
    this.pdfDoc && this.pdfDoc.remove()
  }

  displayPdf() {
    const _this = this

    // Loaded via <script> tag, create shortcut to access PDF.js exports.
    var pdfjsLib = window['pdfjs-dist/build/pdf'];

    // The workerSrc property shall be specified.
    pdfjsLib.GlobalWorkerOptions.workerSrc = '//mozilla.github.io/pdf.js/build/pdf.worker.js';

    this.pdfDoc = null
    this.pageNum = 1
    this.pageRendering = false
    this.pageNumPending = null
    this.scale = 1
    this.canvas = this.containerTarget
    this.ctx = this.canvas.getContext('2d');

    /**
     * Asynchronously downloads PDF.
     */
    pdfjsLib.getDocument(this.urlValue).promise.then(function(pdfDoc_) {
      const pdfDocExists = _this.pdfDoc
      _this.pdfDoc = pdfDoc_
      _this.pageCountTarget.textContent = _this.pdfDoc.numPages

      // Initial/first page rendering
      _this.renderPage(_this.pageNum)
    });
  }

  /**
   * If another page rendering in progress, waits until the rendering is
   * finised. Otherwise, executes rendering immediately.
   */
  queueRenderPage(num) {
    if (this.pageRendering) {
      this.pageNumPending = num;
    } else {
      this.renderPage(num);
    }
  }

  /**
   * Get page info from document, resize canvas accordingly, and render page.
   * @param num Page number.
   */
  renderPage(num) {
    const _this = this
    this.pageRendering = true;
    // Using promise to fetch the page
    this.pdfDoc.getPage(num).then(function(page) {
      const viewport = page.getViewport({
        scale: 1
      })
      _this.canvas.height = viewport.height;
      _this.canvas.width = viewport.width;

      // Render PDF page into canvas context
      const renderContext = {
        canvasContext: _this.ctx,
        viewport: viewport
      };
      const renderTask = page.render(renderContext);

      // Wait for rendering to finish
      renderTask.promise.then(function() {
        _this.pageRendering = false;
        if (_this.pageNumPending !== null) {
          // New page rendering is pending
          _this.renderPage(pageNumPending);
          _this.pageNumPending = null;
        }
      });
    });

    // Update page counters
    this.pageNumTarget.textContent = num;
  }

  /**
   * Displays next page.
   */
  nextPage() {
    if (this.pageNum >= this.pdfDoc.numPages) {
      return;
    }
    this.pageNum++;
    this.queueRenderPage(this.pageNum);
  }
  /**
   * Displays previous page.
   */
  prevPage() {
    if (this.pageNum <= 1) {
      return;
    }
    this.pageNum--;
    this.queueRenderPage(this.pageNum);
  }
}
