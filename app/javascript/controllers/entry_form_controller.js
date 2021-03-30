import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect() {
    this.element.querySelector('textarea').focus()
    this.element.querySelector('textarea').addEventListener('keydown', function(event) {
      if ((event.ctrlKey || event.metaKey) && (event.keyCode === 13 || event.keyCode === 10)) {
        document.querySelector("[submitID]").click()
        new MutationObserver((mutations, observer) => {
          document.getElementById("entry-list-next").click()
          observer.disconnect()
        }).observe(document.getElementById("entry-details"), {subtree: true, childList: true});
      }
    })
  }
}
