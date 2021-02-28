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
    event.preventDefault();
    if (!isNaN(this.currentValue)) {
      document.getElementById(`project_file_${this.currentValue}`)?.classList.remove("font-bold", "text-red-600")
    }
    console.log(event.currentTarget)
    this.currentValue = parseInt(event.currentTarget.id.match(/\d+/))
    event.currentTarget.parentElement.classList.add("font-bold", "text-red-600")
    let url = `${event.currentTarget.href}/entries/${event.currentTarget.getAttribute("first_entry")}`
    window.history.pushState('','', event.currentTarget.href)
    document.getElementById("entry_list").setAttribute("src", url)
  }

}
