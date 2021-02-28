import { Controller } from "stimulus"

export default class extends Controller {
  static values = { }

  connect() {
  }

  click(event) {
    let id = event.currentTarget.id.match(/project_file_(\d+)_entry_(\d+)/)
    document.getElementById("entry-details").setAttribute("src", `/project_files/${id[1]}/entries/${id[2]}`)
  }
}
