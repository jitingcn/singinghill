import { Controller } from "stimulus"

export default class extends Controller {
  static values = { current: Number }

  connect() {
    console.log("connect to file list components!")
    if (!isNaN(this.currentValue)) {
      console.log(this.currentValue)
      document.getElementById(`project_file_${this.currentValue}`)?.classList.add("font-bold", "text-red-600")
      // document.getElementById(`project_file_${this.currentValue}`).scrollIntoView()
    }
  }

  click(event) {
    // event.preventDefault();
    if (!isNaN(this.currentValue)) {
      document.getElementById(`project_file_${this.currentValue}`)?.classList.remove("font-bold", "text-red-600")
    }
    console.log(event.currentTarget)
    this.currentValue = parseInt(event.currentTarget.id.match(/\d+/))
    event.currentTarget.classList.add("font-bold", "text-red-600")
    window.history.pushState('','', event.currentTarget.href)
    if (this.element.hasAttribute("switch-open")) {
      document.getElementById("nav-switch").click()
    }
  }

}
