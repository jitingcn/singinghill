import ApplicationController from './application_controller'
import { throttle } from "lodash"

export default class extends ApplicationController {
  connect() {
    document.getElementById("source").disabled = true
    document.getElementById("english").disabled = true
    document.getElementById("chinese").disabled = true
    this.resize_textarea = throttle(this.resize_textarea, 100).bind(this)
    this.resize_textarea()
  }

  resize_textarea() {
    // let max_height = this.max_height(this.element.querySelectorAll("textarea"))
    let els = this.element.querySelectorAll("textarea")
    for (const el of els) {
      el.style.height = "5px"
      el.style.height = `${el.scrollHeight}px`
      // el.style.height = `${max_height}px`
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
