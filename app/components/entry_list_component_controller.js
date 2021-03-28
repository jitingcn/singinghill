import { Controller } from "stimulus"

export default class extends Controller {
  static targets = []
  static values = {}
  activeElement;
  activeClassList = [ "border", "border-gray-600", "font-semibold", "text-red-600" ]
  url;
  entry;

  connect() {
    console.log("1")
    this.url = new URL(window.location.href)
    this.entry = this.url.searchParams.get("entry")

    if (this.entry == null) {
      let id = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]?.id.match(/(\d+)/)?.[0]
      document.getElementById("entry-details")?.setAttribute("src", `/entries/${id}`)
      document.getElementById("entry-edit")?.setAttribute("src", `/entries/${id}/edit`)
      this.activeElement = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]
      this.activeElement?.classList.add(...this.activeClassList)
      this.url.searchParams.set("entry", id)
      window.history.pushState('','', this.url)
      return
    }

    const id = `entry_list_item_${this.entry}`
    document.getElementById("entry-details")?.setAttribute("src", `/entries/${this.entry}`)
    document.getElementById("entry-edit")?.setAttribute("src", `/entries/${this.entry}/edit`)
    this.activeElement = document.getElementById(id)
    this.activeElement?.classList.add(...this.activeClassList)
    this.activeElement.scrollIntoView()
  }

  click(event) {
    const id = event.currentTarget.id.match(/(\d+)/)?.[0]
    this.url.searchParams.set("entry", id)
    window.history.pushState('','', this.url)
    document.getElementById("entry-edit")?.setAttribute("src", `/entries/${id}/edit`)

    if (this.activeElement != null) {
      this.activeElement.classList.remove(...this.activeClassList)
    }
    this.activeElement = event.currentTarget
    this.activeElement.classList.add(...this.activeClassList)
  }
}
