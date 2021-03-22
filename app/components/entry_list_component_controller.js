import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [  ]
  static values = {  }
  activeElement;
  activeClassList = [ "border", "border-gray-600", "font-semibold", "text-red-600" ]

  connect() {
    let id = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]?.id.match(/(\d+)/)?.[0]
    document.getElementById("entry-details")?.setAttribute("src", `/entries/${id}`)
    this.activeElement = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]
    this.activeElement?.classList.add(...this.activeClassList)
  }

  click(event) {
    if (this.activeElement != null) {
      this.activeElement.classList.remove(...this.activeClassList)
    }
    this.activeElement = event.currentTarget
    this.activeElement.classList.add(...this.activeClassList)
  }
}
