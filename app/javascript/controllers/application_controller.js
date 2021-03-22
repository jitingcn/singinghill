import { Controller } from "stimulus"

export default class extends Controller {
  get classList() {
    return this.element.classList
  }

  dispatch(eventName, { target = this.element, detail = {}, bubbles = true, cancelable = true } = {}) {
    const type = `${this.identifier}:${eventName}`
    const event = new CustomEvent(type, { detail, bubbles, cancelable })
    target.dispatchEvent(event)
    return event
  }

  observeMutations(callback, target = this.element, options = { childList: true, subtree: true }) {
    const observer = new MutationObserver(mutations => {
      observer.disconnect()
      Promise.resolve().then(start)
      callback.call(this, mutations)
    })
    function start() {
      if (target.isConnected) observer.observe(target, options)
    }
    start()
  }
}
