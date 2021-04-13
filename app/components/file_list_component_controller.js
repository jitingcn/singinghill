import ApplicationController from '~/controllers/application_controller'

export default class extends ApplicationController {
  static targets = [ "gotoFile" ]
  static values = { current: Number }
  activeClassList = [ "font-semibold", "text-blue-600", "dark:text-indigo-300" ]

  connect() {
    if (!isNaN(this.currentValue)) {
      document.getElementById(`project_file_${this.currentValue}`)?.classList.add(...this.activeClassList)
      document.getElementById(`project_file_${this.currentValue}`).scrollIntoView({behavior: "auto", block: "center"})
    }
  }

  click(event) {
    // event.preventDefault();
    if (!isNaN(this.currentValue)) {
      document.getElementById(`project_file_${this.currentValue}`)?.classList.remove(...this.activeClassList)
    }
    this.currentValue = parseInt(event.currentTarget.id.match(/\d+/))
    event.currentTarget.classList.add(...this.activeClassList)
    window.history.pushState('','', event.currentTarget.href)
    document.getElementById(`project_file_${this.currentValue}`).scrollIntoView({behavior: "smooth", block: "center"})
  }

  goto(event) {
    event?.preventDefault()
    const file_id = this.gotoFileTarget.value
    if (file_id === '') return
    const url = new URL(window.location.href)
    url.search = ""
    url.searchParams.set("filename", `${file_id}.evd.txt`)
    window.location.href = url
  }

  gotoKeyboard(event) {
    if (event.keyCode === 13) {
      this.goto()
    }
  }
}
