import ApplicationController from '~/controllers/application_controller'

export default class extends ApplicationController {
  static targets = [ "gotoFile" ]
  static values = { current: Number }
  activeClassList = [ "font-semibold", "text-blue-700", "dark:text-indigo-300" ]

  connect() {
    if (!isNaN(this.currentValue)) {
      document.getElementById(`project_file_${this.currentValue}`)?.classList.add(...this.activeClassList)
      document.getElementById(`project_file_${this.currentValue}`)?.scrollIntoView({behavior: "auto", block: "center"})
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
    document.getElementById(`project_file_${this.currentValue}`)?.scrollIntoView({behavior: "smooth", block: "center"})
  }

  async goto(event) {
    event?.preventDefault()
    const fileName = this.gotoFileTarget.value
    if (fileName === '') return

    let path = window.location.pathname.match(/project_files|event|night_conversation|grathmeld_conversation|cosmosphere_random|gift_install/g)[0]
    let response = await fetch(`/${path}/goto/${fileName}.json`)
    if (response.status === 200) {
      let data = await response.json()
      if (data.url === undefined) return -1

      window.location.href = data.url.replace(/\.json$/, '')
    }
  }

  async gotoKeyboard(event) {
    if (event.keyCode === 13) {
      let ret = await this.goto()
      if (ret === -1) {
        event.target.value = ""
      }
    }
  }
}
