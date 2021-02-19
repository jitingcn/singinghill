import { Controller } from "stimulus"

export default class extends Controller {
  static values = { current: Number }

  connect() {
    console.log("connect to file list")
    if (this.currentValue !== 0) {
      const file_name =  `${this.currentValue - 1}.evd.txt`
      console.log(file_name)
      document.getElementById(file_name).classList.add("font-bold", "text-red-600")
      document.getElementById(file_name).scrollIntoView()
    }
  }

  click(event) {
    event.preventDefault();
    if (this.currentValue !== 0) {
      const file_name = `${this.currentValue - 1}.evd.txt`;
      document.getElementById(file_name).classList.remove("font-bold", "text-red-600")
    }
    this.currentValue = parseInt(event.currentTarget.text.match(/\d+/))+1
    const file_name = `${this.currentValue - 1}.evd.txt`
    document.getElementById(file_name).classList.add("font-bold", "text-red-600")
    window.history.pushState('','', `/project_files/${file_name}`)
    fetch(`/project_files/${file_name}`)
        .then(response => response.text())
        .then((html) => {
            document.getElementById('editor').innerHTML =
            new DOMParser().parseFromString(html, 'text/html').getElementById('editor').innerHTML
        })

  }

}
