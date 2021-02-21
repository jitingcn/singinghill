import { Controller } from "stimulus"

export default class extends Controller {
  static values = { entry: String }
  connect() {
  }
  click(event) {
    const entry = JSON.parse(event.currentTarget.getAttribute("value"))
    console.log(entry)
    document.getElementById("source").value = entry["source"]
    document.getElementById("english").value = entry["english"]
    document.getElementById("chinese").value = entry["chinese"]
  }
}
