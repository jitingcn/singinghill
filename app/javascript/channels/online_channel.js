import consumer from "./consumer";

const onlineChannel = consumer.subscriptions.create({channel: "OnlineChannel"}, {
  connected() {
    // Called when the subscription is ready for use on the server
    this.install()
    this.appear()
    this.current_online()
    setInterval(function() {
      onlineChannel.perform('ping', {});
    }, 5000);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    this.uninstall()
  },

  appear() {
    setTimeout(() => {
      onlineChannel.perform("appear", {location: window.location.href})
	}, 100)
  },

  current_online() {
    onlineChannel.perform("current_online")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    for (const [key, value] of Object.entries(data)) {
      if (key === "message") {
        console.log(value);
      } else {
        console.log(key, value);
      }
    }
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
