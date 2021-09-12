import { Modal } from "tailwindcss-stimulus-components"

export default class extends Modal {
  connect() {
    console.log("modal")
    super.connect()
  }
}
