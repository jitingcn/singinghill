// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

// import { cable } from "@hotwired/turbo-rails"
// // https://caniuse.com/?search=top%20level%20await
// export default await cable.getConsumer()

import { createConsumer } from "@rails/actioncable"
export default createConsumer()
