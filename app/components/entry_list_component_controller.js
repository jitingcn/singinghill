import { Controller } from "stimulus"

export default class extends Controller {
  static values = { }

  connect() {
    let id = document.querySelectorAll('[id^=entry_list_item]')?.[0]?.id.match(/(\d+)/)?.[0]
    document.getElementById("entry-details")?.setAttribute("src", `/entries/${id}`)
  }

  click(event) {
    console.log(event.currentTarget)
  }
}
