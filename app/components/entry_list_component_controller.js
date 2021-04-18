import ApplicationController from '~/controllers/application_controller'
import { throttle } from "lodash"

export default class extends ApplicationController {
  static targets = []
  static values = {}
  activeElement
  nextElement
  activeClassList = [ "font-semibold", "text-blue-700", "dark:text-indigo-300" ]
  url
  entry

  connect() {
    this.next = throttle(this.next, 1000).bind(this)
    this.url = new URL(window.location.href)
    this.entry = this.url.searchParams.get("entry")

    if (this.entry == null) {
      let id = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]?.id.match(/(\d+)/)?.[0]
      this.activeElement = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]
      this.activeElement?.classList.add(...this.activeClassList)
      this.nextElement = this.activeElement.nextElementSibling
      if (this.entry != null) return

      this.url.searchParams.set("entry", id)
      window.history.pushState('','', this.url)
      return
    }

    const id = `entry_list_item_${this.entry}`
    this.activeElement = document.getElementById(id)
    if (this.activeElement == null) {
      let id = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]?.id.match(/(\d+)/)?.[0]
      this.activeElement = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]
      this.activeElement?.classList.add(...this.activeClassList)
      this.nextElement = this.activeElement.nextElementSibling

      this.url.searchParams.set("entry", id)
      window.history.pushState('','', this.url)
      return
    }
    this.activeElement?.classList.add(...this.activeClassList)
    this.activeElement.scrollIntoView({behavior: "auto", block: "center"})
    this.nextElement = this.activeElement.nextElementSibling
  }

  click(event) {
    const id = event.currentTarget.id.match(/(\d+)/)?.[0]
    this.url.searchParams.set("entry", id)
    window.history.pushState('','', this.url)
    // document.getElementById("entry-edit")?.setAttribute("src", `/entries/${id}/edit`)

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
      const nextFile = document.querySelector("a.text-blue-700[data-turbo-frame='editor']").nextElementSibling
      if (nextFile) nextFile.click()
      return
    }

    setTimeout(() => {
      this.nextElement.click()
    }, 200)
  }
}
