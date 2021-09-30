import { Controller } from "@hotwired/stimulus"
import { Uploader } from "../components/uploader"
import * as FilePond from 'filepond';
// Import the plugin code
import FilePondPluginImagePreview from 'filepond-plugin-image-preview';
import FilePondPluginFileEncode from 'filepond-plugin-file-encode';
import FilePondPluginFileValidateType from 'filepond-plugin-file-validate-type';
import FilePondPluginFileMetadata from 'filepond-plugin-file-metadata';
// Import the plugin styles
import 'filepond-plugin-image-preview/dist/filepond-plugin-image-preview.css';

// Register the plugin
FilePond.registerPlugin(
  FilePondPluginImagePreview,
  FilePondPluginFileEncode,
  FilePondPluginFileValidateType,
  FilePondPluginFileMetadata
);

let fileUploadingCount = 0

export default class extends Controller {
  static targets = ["container"]
  static values = { filetypes: Array }

  initialize() {
    this.form = this.element.form;
    this.filetypesValue ||= ['image/png', 'image/jpeg', 'image/gif'];

    this.pond = FilePond.create(this.element, {
      labelIdle: `Drag & Drop your file or <span class="filepond--label-action">Browse</span>`,
      acceptedFileTypes: this.filetypesValue,
      server: {
          process: this.uploadFile,
      },
      onaddfilestart: (file) => { this.isLoadingCheck() },
      onprocessfile: (files) => { this.isLoadingCheck() }
    });
    const pqinaLogo = document.querySelector('.filepond--credits');
    pqinaLogo && pqinaLogo.remove();
  }

  isLoadingCheck() {
    const isLoading = this.pond.getFiles().filter(x=>x.status !== 5).length !== 0
    const submitButtons = this.form.querySelectorAll('[type="submit"]')
    if(isLoading) {
      fileUploadingCount += 1
      submitButtons.forEach((submit) => {
        submit.disabled = true
        submit.dataset.originalValue = submit.value
        submit.value = 'Uploading file...'
      })
    } else {
      fileUploadingCount -= 1
      if (fileUploadingCount === 0) {
        submitButtons.forEach((submit) => {
          submit.disabled = false
          submit.value = submit.dataset.originalValue
        })
      }
    }
  }

  uploadFile(fieldName, file, metadata, load, error, progress, abort) {
    const uploader = new Uploader(file, '/rails/active_storage/direct_uploads', progress, load);
    uploader.uploadFile();
  };
}
