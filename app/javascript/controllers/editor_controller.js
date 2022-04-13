import ApplicationController from './application_controller'

export default class extends ApplicationController {
  connect() {
    super.connect()
    document.addEventListener('keydown', this.keyboard.bind(this))
  }

  submit(event) {
    let submitID = event.currentTarget.getAttribute("submitID")
    // document.getElementById("editor").setAttribute(`${submitID}_submitted`, "")
  }

  keyboard(event) {
    // console.debug(event.keyCode)
    if (document.getElementById(this.currentEntryID()).hasAttribute("loading")) return

    if (event.ctrlKey || event.metaKey)  {
      switch (event.keyCode) {
        // 上方向键 切换上一个条目
        case 38:
          this.previousEntry()
          break
        // 下方向键 切换下一个条目
        case 40:
          this.nextEntry()
          break
        // 左方向键 切换上一个文件
        case 37:
          this.previousFile()
          break
        // 右方向键 切换下一个文件
        case 39:
          this.nextFile()
          break
      }
    }
  }

  currentEntryID() {
    return document.querySelector("#entry-details > turbo-frame").id
  }

  currentEntry() {
    const id = this.currentEntryID().replace(/entry_(\d+)/, 'entry_list_item_$1')
    return document.getElementById(id)
  }

  previousEntry() {
     if (this.currentEntry().previousElementSibling == null) {
       this.previousFile()
     } else {
       this.currentEntry().previousElementSibling.click()
     }
  }

  nextEntry() {
    if (this.currentEntry().nextElementSibling == null) {
      this.nextFile()
    } else {
      this.currentEntry().nextElementSibling.click()
    }
  }

  currentFile() {
    return document.querySelector("a.text-blue-700[data-turbo-frame='editor']")
  }

  previousFile() {
    const previousFile = this.currentFile()?.previousElementSibling
    if (previousFile) {
      previousFile.click()
    } else {
      document.querySelector("#file_list_nav > nav > .prev > a").click()
      document.querySelector("#file_list_body").lastElementChild.click()
    }
    setTimeout(() => {
      document.querySelector("#entry_list_body").lastElementChild.click()
      document.querySelector("#entry_list_body").lastElementChild.scrollIntoView()
    }, 700)
  }

  nextFile() {
    const nextFile = this.currentFile()?.nextElementSibling
    if (nextFile) {
      nextFile.click()
    } else {
      document.querySelector("#file_list_nav > nav > .next > a").click()
      setTimeout(() => {
        document.querySelector("#file_list_body").firstElementChild.click()
      }, 700)
    }
  }

  disconnect() {
    document.removeEventListener('keydown', this.keyboard.bind(this))
    super.disconnect();
  }
}
