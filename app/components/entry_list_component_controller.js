import { Controller } from "stimulus"
let throttle = require('lodash/throttle');

export default class extends Controller {
  static targets = []
  static values = {}
  activeElement;
  nextElement;
  activeClassList = [ "font-semibold", "text-blue-600", "dark:text-indigo-300" ]
  url;
  entry;

  connect() {
    this.next = throttle(this.next, 1000).bind(this)
    this.url = new URL(window.location.href)
    this.entry = this.url.searchParams.get("entry")

    if (this.entry == null) {
      let id = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]?.id.match(/(\d+)/)?.[0]
      document.getElementById("entry-details")?.setAttribute("src", `/entries/${id}`)
      document.getElementById("entry-edit")?.setAttribute("src", `/entries/${id}/edit`)
      this.activeElement = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]
      this.activeElement?.classList.add(...this.activeClassList)
      this.nextElement = this.activeElement.nextElementSibling
      this.url.searchParams.set("entry", id)
      window.history.pushState('','', this.url)
      return
    }

    const id = `entry_list_item_${this.entry}`
    document.getElementById("entry-details")?.setAttribute("src", `/entries/${this.entry}`)
    document.getElementById("entry-edit")?.setAttribute("src", `/entries/${this.entry}/edit`)
    this.activeElement = document.getElementById(id)
    this.activeElement?.classList.add(...this.activeClassList)
    this.activeElement.scrollIntoView({behavior: "auto", block: "center"})
    this.nextElement = this.activeElement.nextElementSibling
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
    this.activeElement.scrollIntoView({behavior: "smooth", block: "center"})
    this.nextElement = this.activeElement.nextElementSibling
  }

  next() {
    if (this.nextElement == null) {
      const nextFile = document.querySelector("a.text-blue-600[data-turbo-frame='editor']").nextElementSibling
      if (nextFile) nextFile.click()
    }

    setTimeout(() => {
      this.nextElement.click()
    }, 200)
  }
}
