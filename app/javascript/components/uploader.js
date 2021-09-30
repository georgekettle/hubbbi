import { DirectUpload } from "@rails/activestorage";

class Uploader {
  constructor(file, url, progress, onLoad) {
    this.file = file
    this.url = url
    this.progress = progress
    this.onLoad = onLoad
    // initilize direct upload
    this.upload = new DirectUpload(this.file, this.url, this)
  }

  uploadFile() {
    // start upload
    this.upload.create((error, blob) => {
      if (error) {
        console.log(error)
      } else {
        this.onLoad(blob.signed_id)
      }
    })
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress",
      event => this.directUploadDidProgress(event))
  }

  directUploadDidProgress(e) {
    this.progress(e.lengthComputable, e.loaded, e.total)
  }
}

export { Uploader }
