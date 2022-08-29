import consumer from "./consumer";
import {LitElement, html} from 'lit';
import {repeat} from 'lit/directives/repeat.js';
import { uniqBy } from "lodash";

let online = { channel: null, element: null, record: [] };
online.channel = consumer.subscriptions.create({channel: "OnlineChannel"}, {
  connected() {
    // Called when the subscription is ready for use on the server
    this.install()
    this.appear()
    setInterval(function() {
      online.channel.perform('ping', {});
    }, 5000);
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    this.uninstall()
  },

  appear() {
    setTimeout(() => {
      online.channel.perform("appear", {location: window.location.href})
	}, 300)
  },

  current_online() {
    online.channel.perform("current_online")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    for (const [key, value] of Object.entries(data)) {
      switch (key) {
        case "message":
          console.log(value);
          break;
        case "current_online":
          online.record = online.element.online_users = value;
          break;
        case "appear":
          online.record = online.element.online_users = online.element.online_users.map((record) => {
            if (record.id === value[0]) {
              record.location = value[1]
            }
            return record;
          })
          break;
        case "drop":
          online.record = online.element.online_users = online.element.online_users.filter((record) => {
            return record.id !== value
          })
          break;
        default:
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
window.online = online;

export class OnlineUsers extends LitElement {
  static properties = {
    online_users: {},
  };

  constructor() {
    super();
    this.online = online;
  }

  createRenderRoot() {
    return this;
  }

  locationToPath(location) {
    return location.replace(/^https?:\/\/[^\/]+/, '');
  }

  locationToTitle(location) {
    const path = this.locationToPath(location);
    switch (path) {
      case "/":
        return "首页";
      case path.match(/^\/(\w+)$/)?.input:
        return path.match(/^\/(\w+)$/)[1];
      case path.match(/^\/([^_]+)(_)?(\w+)?\/(\d+)(\?entry=(\d+))?/)?.input:
        const match = path.match(/^\/([^_]+)(_\w+)?\/(\d+)(\?entry=(\d+))?/)
        const entry = match[5] ? `${match[5]}` : ""
        if (match[2] !== undefined) {
          return `${match[1][0]}${match[2][1]}: ${entry}`;
        } else {
          return `${match[1]}: ${entry}`;
        }
      default:
        return path;
    }
  }

  uniqueUser() {
      // return this.online_users // debug
      return uniqBy(this.online_users, 'user');
  }

  renderAvatar(record) {
      return record.avatar ?
          html`
              <img class="w-5 h-5 object-cover" src="${record.avatar}" alt="${record.user}">
          ` :
          html`
              <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" viewBox="0 0 20 20"
                   fill="currentColor">
                  <path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd"/>
              </svg>
          `

  }

  render() {
    return html`
      <div class="dropdown">
        <label tabindex="0" class="flex items-center">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 mr-1 ${this.online_users.length === 0 ? 'hidden' : ''}" viewBox="0 0 20 20" fill="currentColor">
              <path fill-rule="evenodd" d="M5.293 7.293a1 1 0 011.414 0L10 10.586l3.293-3.293a1 1 0 111.414 1.414l-4 4a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
          <span class="flex flex-row items-center">
            ${repeat(this.uniqueUser(), 
                    (record) => record.user,
                    (record, index)=> html`
              <span class="border border-black rounded-sm bg-gray-100 -ml-1.5 shadow ${index > (3-1) ? 'hidden sm:block' : ''} ${index > (5-1) ? 'hidden' : ''}" 
                    style="z-index: ${110-index};">
                  ${this.renderAvatar(record)}
              </span>`
            )}
          </span>
        </label>
        <ul tabindex="0" class="dropdown-content menu menu-compact bg-gray-300/90 dark:bg-gray-700/90 rounded w-max">
            ${repeat(this.online_users,
                    (record) => `detail_${record.id}`,
                    (record, index)=> html`
                      <li class="">
                        <a href="${this.locationToPath(record.location)}" class="flex !px-3 !py-2 flex-grow w-full">
                          <span class="shrink-0 mr-1">${this.renderAvatar(record)}</span>
                          <span class="shrink-0 mr-3">${record.user}</span>
                          <span class="shrink-0 grow text-right">${this.locationToTitle(record.location)}</span>
                        </a>
                      </li>`
            )}
        </ul>
      </div>
    `;
  }

  connectedCallback() {
    super.connectedCallback()
    this.online_users = this.online.record;
    this.online.element = this;
  }

  disconnectedCallback() {
    super.disconnectedCallback()
    this.online.element.innerHTML = '';
  }
}
customElements.define('online-users', OnlineUsers);
