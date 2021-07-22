import consumer from "./consumer";

const onlineChannel = consumer.subscriptions.create("OnlineChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    this.install()
    this.current_online()
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    this.uninstall()
  },

  appear() {
    setTimeout(() => {
      onlineChannel.perform("appear", {location: window.location.href})
	}, 50)
  },

  current_online() {
    onlineChannel.perform("current_online")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(...[data])
  },

  install() {
    window.addEventListener("popstate", this.appear)
    document.addEventListener("turbo:click", this.appear)
  },

  uninstall() {
    window.removeEventListener("popstate", this.appear)
    document.removeEventListener("turbo:click", this.appear)
  }
});
