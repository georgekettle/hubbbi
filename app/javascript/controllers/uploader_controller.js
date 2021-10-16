import { Controller } from "@hotwired/stimulus"
import { Uploader } from "../components/uploader"
import * as FilePond from 'filepond'

// Import the plugin code
import FilePondPluginFileEncode from 'filepond-plugin-file-encode'
import FilePondPluginFileValidateType from 'filepond-plugin-file-validate-type'
import FilePondPluginFileValidateSize from 'filepond-plugin-file-validate-size'
import FilePondPluginFilePoster from 'filepond-plugin-file-poster'
import { FilePondPluginImageEditor } from '../plugins/filepond-plugin-image-editor/FilePondPluginImageEditor.js'

// Import the plugin styles
import 'filepond-plugin-file-poster/dist/filepond-plugin-file-poster.css';

import {
    // Image editor
    openEditor,
    markupEditorToolbar,
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
  FilePondPluginFileEncode,
  FilePondPluginFileValidateType,
  FilePondPluginFileValidateSize,
  FilePondPluginFilePoster,
  FilePondPluginImageEditor,
);

const editIcon = `<svg class="stroke-current text-white h-3.5 w-3.5" width="20px" height="20px" viewBox="0 0 20 20" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
    <g id="Page-1" stroke-width="1" fill="none" fill-rule="evenodd">
        <g id="Interface,-Essential/Pen,-Edit" transform="translate(-2.000000, -2.000000)">
            <g id="Group" transform="translate(-0.000000, -0.000000)">
                <g id="Path">
                    <polygon stroke="none" points="0 0 24.0000001 0 24.0000001 24.0000001 0 24.0000001"></polygon>
                    <path d="M17.5400001,10.12 L13.8800001,6.46000003" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                    <path d="M6.25100003,21.0000001 L3.00000001,21.0000001 L3.00000001,17.7490001 C3.00000001,17.4840001 3.10500001,17.2290001 3.29300001,17.0420001 L16.6270001,3.70700002 C17.0180001,3.31600001 17.6510001,3.31600001 18.0410001,3.70700002 L20.2920001,5.95800002 C20.6830001,6.34900003 20.6830001,6.98200003 20.2920001,7.37200003 L6.95800003,20.7070001 C6.77100003,20.8950001 6.51600003,21.0000001 6.25100003,21.0000001 L6.25100003,21.0000001 Z" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"></path>
                </g>
            </g>
        </g>
    </g>
</svg>`

let fileUploadingCount = 0

export default class extends Controller {
  static targets = ["container"]
  static values = {
    filetypes: { type: Array, default: ['image/png', 'image/jpeg', 'image/gif'] },
    max: { type: String, default: '10MB' },
    uploading: { type: Boolean, default: false },
    heightAspect: { type: Number, default: 9 },
    widthAspect: { type: Number, default: 16 },
    maxRes: { type: Number, default: 3000 },
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
      // set max file size to be allowed
      maxFileSize: this.maxValue,
      // filepond events
      onaddfilestart: this.onAddFileStart.bind(this),
      onprocessfilestart: this.onProcessFileStart.bind(this),
      onprocessfile: this.onProcessFile.bind(this),
      onerror: this.enableSubmitButtons.bind(this),
      // max height of image poster shown to user in input
      filePosterMaxHeight: 256,
      // edit icon
      imageEditorIconEdit: editIcon,
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
                      width: this.maxResValue,
                      height: this.maxResValue,
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
              imageCropAspectRatio: this.widthAspectValue / this.heightAspectValue,
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
    if (this.uploadingValue === false) {
      fileUploadingCount += 1
      this.submitBtn.disabled = true
      this.submitBtn.value = 'Uploading file...'
    }
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

  onAddFileStart() {
    this.disableSubmitButtons()
    this.uploadingValue = true
  }

  onProcessFileStart() {
    this.disableSubmitButtons()
    this.uploadingValue = true
  }

  onProcessFile() {
    this.uploadingValue = false
    this.enableSubmitButtons()
  }
}
