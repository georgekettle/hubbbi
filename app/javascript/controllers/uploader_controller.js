import { Controller } from "stimulus"
import { Uploader } from "../components/uploader"
import * as FilePond from 'filepond';
// Import the plugin code
import FilePondPluginImagePreview from 'filepond-plugin-image-preview';
import FilePondPluginFileEncode from 'filepond-plugin-file-encode';
import FilePondPluginFileValidateType from 'filepond-plugin-file-validate-type';
// Import the plugin styles
import 'filepond-plugin-image-preview/dist/filepond-plugin-image-preview.css';

// Register the plugin
FilePond.registerPlugin(
  FilePondPluginImagePreview,
  FilePondPluginFileEncode,
  FilePondPluginFileValidateType
);

export default class extends Controller {
  static targets = ["container"]

  initialize() {
    this.form = this.element.form;

    this.pond = FilePond.create(this.element, {
      labelIdle: `Drag & Drop your picture or <span class="filepond--label-action">Browse</span>`,
      acceptedFileTypes: ['image/png', 'image/jpeg', 'image/gif'],
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
      submitButtons.forEach((submit) => {
        submit.disabled = true
        submit.dataset.originalValue = submit.value
        submit.value = 'Uploading image...'
      })
    } else {
      submitButtons.forEach((submit) => {
        submit.disabled = false
        submit.value = submit.dataset.originalValue
      })
    }
  }

  uploadFile(fieldName, file, metadata, load, error, progress, abort) {
    const uploader = new Uploader(file, '/rails/active_storage/direct_uploads', progress, load);
    uploader.uploadFile();
  };
}



