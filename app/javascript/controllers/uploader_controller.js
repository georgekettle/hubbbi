import { Controller } from "@hotwired/stimulus"
import { Uploader } from "../components/uploader"
import * as FilePond from 'filepond'
// Import the plugin code
import FilePondPluginImagePreview from 'filepond-plugin-image-preview'
import FilePondPluginFileEncode from 'filepond-plugin-file-encode'
import FilePondPluginFileValidateType from 'filepond-plugin-file-validate-type'
import FilePondPluginFileValidateSize from 'filepond-plugin-file-validate-size'
import FilePondPluginFilePoster from 'filepond-plugin-file-poster'
import { FilePondPluginImageEditor } from '../plugins/filepond-plugin-image-editor/FilePondPluginImageEditor.js'

// Import the plugin styles
import 'filepond-plugin-image-preview/dist/filepond-plugin-image-preview.css'

import {
    // Image editor
    openEditor,
    processImage,
    createDefaultImageReader,
    createDefaultImageWriter,
    createDeafultImageOrienter,

    // Only needed if loading legacy image editor data
    legacyDataToImageState,

    // Import the editor default configuration
    getEditorDefaults,
} from '../plugins/pintura/pintura.js';

// Register the plugin
FilePond.registerPlugin(
  FilePondPluginImagePreview,
  FilePondPluginFileEncode,
  FilePondPluginFileValidateType,
  FilePondPluginFileValidateSize,
  FilePondPluginImageEditor
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
      // FilePond generic properties
        filePosterMaxHeight: 256,

        // FilePond Image Editor plugin properties
        imageEditor: {
            // Maps legacy data objects to new imageState objects (optional)
            legacyDataToImageState: legacyDataToImageState,

            // Used to create the editor (required)
            createEditor: openEditor,

            // Used for reading the image data. See JavaScript installation for details on the `imageReader` property (required)
            imageReader: [
                createDefaultImageReader,
                {
                    // createDefaultImageReader options here
                },
            ],

            // Can leave out when not generating a preview thumbnail and/or output image (required)
            imageWriter: [
                createDefaultImageWriter,
                {
                    // We'll resize images to fit a 512 × 512 square
                    targetSize: {
                        width: 512,
                        height: 512,
                    },
                },
            ],

            // Used to poster and output images, runs an invisible "headless" editor instance.
            imageProcessor: processImage,

            // Pintura Image Editor options
            editorOptions: {
                // Pass the editor default configuration options
                ...getEditorDefaults(),

                // This will set a square crop aspect ratio
                imageCropAspectRatio: 1,
            },
        },
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
