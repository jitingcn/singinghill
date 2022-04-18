import ApplicationController from '~/controllers/application_controller'
import { throttle } from "lodash"
import { useResize } from 'stimulus-use'

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
    const height = this.getBodyHeight()
    if (height) {
      document.getElementById("entry_list_body").style.height = `${height}px`
    }
    this.setBodyHeight = throttle(this.setBodyHeight, 120).bind(this)

    useResize(this, {element: document.getElementById("entry_list_body")})

    if (this.entry == null) {
      let id = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]?.id.match(/(\d+)/)?.[0]
      this.activeElement = this.element.querySelectorAll('[id^=entry_list_item]')?.[0]
      this.activeElement?.classList.add(...this.activeClassList)
      this.nextElement = this.activeElement.nextElementSibling
      if (this.entry != null) return

      this.url.searchParams.set("entry", id)
      Turbo.navigator.history.push(this.url, `entry_${id}`)
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
      Turbo.navigator.history.push(this.url, `entry_${id}`)
      return
    }
    this.activeElement?.classList.add(...this.activeClassList)
    this.activeElement.scrollIntoView({behavior: "auto", block: "center"})
    this.nextElement = this.activeElement.nextElementSibling
  }

  click(event) {
    const id = event.currentTarget.id.match(/(\d+)/)?.[0]
    this.url.searchParams.set("entry", id)
    Turbo.navigator.history.push(this.url, `entry_${id}`)

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

  resize({height}) {
    this.setBodyHeight(height)
  }

  getBodyHeight() {
    return localStorage.getItem("entry_list_height")
  }

  setBodyHeight(height) {
    localStorage.setItem("entry_list_height", height)
  }
}
