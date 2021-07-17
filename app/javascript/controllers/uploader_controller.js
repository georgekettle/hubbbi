import { Controller } from "stimulus"
import { Uploader } from "../components/uploader"
import * as FilePond from 'filepond';
// Import the plugin code
import FilePondPluginImagePreview from 'filepond-plugin-image-preview';
import FilePondPluginFileEncode from 'filepond-plugin-file-encode';
import FilePondPluginImageEdit from 'filepond-plugin-image-edit';
// Import the plugin styles
import 'filepond-plugin-image-preview/dist/filepond-plugin-image-preview.css';

// Register the plugin
FilePond.registerPlugin(
  FilePondPluginImagePreview,
  FilePondPluginFileEncode,
  FilePondPluginImageEdit
);

export default class extends Controller {
  static targets = ["container"]

  initialize() {
    this.form = this.element.form;

    this.pond = FilePond.create(this.element, {
      server: {
          process: this.uploadFile,
      },
    });
  }

  uploadFile(fieldName, file, metadata, load, error, progress, abort) {
    const uploader = new Uploader(file, '/rails/active_storage/direct_uploads', progress, load);
    uploader.uploadFile();
  };
}



