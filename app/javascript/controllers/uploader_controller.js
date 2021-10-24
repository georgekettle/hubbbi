import { Controller } from "@hotwired/stimulus"
import { Uploader } from "../components/uploader"
import * as FilePond from 'filepond';
// Import the plugin code
// import FilePondPluginImagePreview from 'filepond-plugin-image-preview';
import FilePondPluginFileEncode from 'filepond-plugin-file-encode';
import FilePondPluginFileValidateType from 'filepond-plugin-file-validate-type';
import FilePondPluginFileValidateSize from 'filepond-plugin-file-validate-size';
// Import the plugin styles
// import 'filepond-plugin-image-preview/dist/filepond-plugin-image-preview.css';

// Register the plugin
FilePond.registerPlugin(
  // FilePondPluginImagePreview,
  FilePondPluginFileEncode,
  FilePondPluginFileValidateType,
  FilePondPluginFileValidateSize
);

let fileUploadingCount = 0

export default class extends Controller {
  static targets = ["container"]
  static values = {
    filetypes: { type: Array, default: ['image/png', 'image/jpeg', 'image/gif'] },
    max: { type: String, default: '10MB' },
    uploading: { type: Boolean, default: false }
  }

  initialize() {
    this.form = this.element.form;
    this.initSubmitButton()

    this.pond = FilePond.create(this.element, {
      labelIdle: `Drag & Drop your file or <span class="filepond--label-action">Browse</span>`,
      acceptedFileTypes: this.filetypesValue,
      server: {
          process: this.uploadFile,
      },
      maxFileSize: this.maxValue,
      onaddfilestart: this.disableSubmitButtons.bind(this),
      onprocessfile: this.enableSubmitButtons.bind(this),
      onerror: this.enableSubmitButtons.bind(this),
    });
    const pqinaLogo = document.querySelector('.filepond--credits');
    pqinaLogo && pqinaLogo.remove();
  }

  initSubmitButton() {
    this.submitBtn = this.form.querySelector('[type="submit"]')
    this.submitText = this.submitBtn.value
  }

  disableSubmitButtons() {
    fileUploadingCount += 1
    this.submitBtn.disabled = true
    this.submitBtn.value = 'Uploading file...'
  }

  enableSubmitButtons() {
    fileUploadingCount -= 1
    if (fileUploadingCount === 0) {
      this.submitBtn.disabled = false
      this.submitBtn.value = this.submitText
    }
  }

  uploadFile(fieldName, file, metadata, load, error, progress, abort) {
    const videoAudioRegex = /(audio\/|video\/).*/gm
    const url = videoAudioRegex.test(file.type) ? '/cloudinary_video_direct_uploads' : '/rails/active_storage/direct_uploads'
    const uploader = new Uploader(file, url, progress, load)
    uploader.uploadFile()
  }
}
