import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "form" ]

  connect() {
  }

  click() {
  }

  // process(event) {
  //   const file = document.getElementById("file").files[0];
  //   if (!file) {
  //     return;
  //   }
  //   const reader = new FileReader();
  //   reader.onload = function(e) {
  //     const contents = e.target.result;
  //
  //     console.log(array)
  //     fetch("/portals.json", {
  //       method: "POST",
  //       body: JSON.stringify({file_content: contents}),
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'X-CSRF-Token': this.formTarget.getElementsByName('authenticity_token')[0].content
  //       },
  //       credentials: 'same-origin'
  //     }).then(res => {
  //       console.log("Request complete! response:", res);
  //       if (res.ok===true) {
  //         window.location.replace('/portals')
  //       }
  //     });
  //     // var element = document.getElementById('file-content');
  //     // element.textContent = array;
  //   };
  //   reader.readAsText(file);
  // }
}
