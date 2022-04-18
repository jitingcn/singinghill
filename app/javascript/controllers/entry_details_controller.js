import ApplicationController from './application_controller'
import { throttle } from "lodash"

export default class extends ApplicationController {
  connect() {
    document.getElementById("source").disabled = true
    if (document.getElementById("english")) {
      document.getElementById("english").disabled = true
    }
    document.getElementById("chinese").disabled = true
    this.resize_textarea = throttle(this.resize_textarea, 100).bind(this)
    this.resize_textarea()
    const src = this.element.parentNode.getAttribute("src")
    document.getElementById("entry-edit")?.setAttribute("src", `${src}/edit`)
  }

  resize_textarea() {
    const ua = navigator.userAgent;
    const isMobile = /Android|webOS|iPhone|iPad/i.test(ua);
    let max_height = this.max_height(this.element.querySelectorAll("textarea"))
    let els = this.element.querySelectorAll("textarea")
    for (const el of els) {
      el.style.height = "5px"
      if (isMobile) {
        el.style.height = `${el.scrollHeight}px`
      } else {
        el.style.height = `${max_height}px`
      }
    }
  }

  max_height(els) {
    let size = 0
    for (const el of els) {
      el.style.height = "5px"
      if (size < el.scrollHeight) {
        size = el.scrollHeight
      }
    }
    return size
  }
}
