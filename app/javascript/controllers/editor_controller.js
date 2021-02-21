import { Controller } from "stimulus"

export default class extends Controller {
  connect() {
    document.getElementById("source").disabled = true
    document.getElementById("english").disabled = true
  }
}
