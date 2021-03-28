import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "gotoFile" ]
  static values = { current: Number }

  connect() {
    if (!isNaN(this.currentValue)) {
      document.getElementById(`project_file_${this.currentValue}`)?.classList.add("font-bold", "text-red-600")
      // document.getElementById(`project_file_${this.currentValue}`).scrollIntoView()
    }
  }

  click(event) {
    // event.preventDefault();
    if (!isNaN(this.currentValue)) {
      document.getElementById(`project_file_${this.currentValue}`)?.classList.remove("font-bold", "text-red-600")
    }
    this.currentValue = parseInt(event.currentTarget.id.match(/\d+/))
    event.currentTarget.classList.add("font-bold", "text-red-600")
    window.history.pushState('','', event.currentTarget.href)
    if (this.element.hasAttribute("switch-open")) {
      document.getElementById("nav-switch").click()
    }
  }

  goto(event) {
    const file_id = this.gotoFileTarget.value
    const url = new URL(window.location.href)
    url.search = ""
    url.searchParams.set("filename", `${file_id}.evd.txt`)
    window.location.href = url
  }
}
