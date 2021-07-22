// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { cable } from "@hotwired/turbo-rails"
const consumer = await cable.getConsumer()

export default consumer
