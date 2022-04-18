import ApplicationController from './application_controller'
import { throttle } from "lodash"

export default class extends ApplicationController {
  textarea;

  connect() {
    const ua = navigator.userAgent;
    const isMobile = /Android|webOS|iPhone|iPad/i.test(ua);
    if (isMobile) return  // disable auto focus and hotkey feature for mobile device

    this.textarea = this.element.querySelector('textarea')
    this.resizeTextarea()
    this.textarea.focus()
    this.keydown = throttle(this.keydown, 700, { 'leading': false }).bind(this)
  }

  keydown(event) {
    if (event.target.hasAttribute("loading")) return

    if ((event.ctrlKey || event.metaKey) && (event.keyCode === 13 || event.keyCode === 10)) {
      event.target.setAttribute("loading", '')
      document.querySelector("[submitID]").click()
      new MutationObserver((mutations, observer) => {
        document.getElementById("entry-list-next").click()
        observer.disconnect()
      }).observe(document.getElementById("entry-details"), {subtree: true, childList: true});
    }
  }

  autoResize() {
    console.log("autoResize")
    this.textarea.style.height = "auto";
    this.textarea.style.height = this.textarea.scrollHeight + "px";
  }

  resizeTextarea() {
    this.textarea.style.height = (this.textarea.scrollHeight+10) + 'px'
  }
}
