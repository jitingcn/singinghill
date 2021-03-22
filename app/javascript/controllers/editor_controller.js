import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect() {

  }

  submit(event) {
    let submitID = event.currentTarget.getAttribute("submitID")
    // document.getElementById("editor").setAttribute(`${submitID}_submitted`, "")
  }
}
