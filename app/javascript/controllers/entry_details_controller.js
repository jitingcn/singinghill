import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect() {
    document.getElementById("source").disabled = true
    document.getElementById("english").disabled = true
    document.getElementById("chinese").disabled = true
    let max_height = this.max_height(this.element.querySelectorAll("textarea"))
    this.resize_textarea(max_height, this.element.querySelectorAll("textarea"))

    let id = this.element.id

    // if (!document.getElementById("editor").hasAttribute(`${id}_submitted`)) {
      document.getElementById("entry_edit_button").click()
    // }
  }

  resize_textarea(height, els) {
    for (const el of els) {
      el.style.height = `${height}px`
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
