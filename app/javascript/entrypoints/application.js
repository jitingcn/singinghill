// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log('Vite ⚡️ Rails')
import '~/stylesheets/application.css'

import Rails from "@rails/ujs"
try { Rails.start() } catch { }

import * as ActiveStorage from "@rails/activestorage"
import LocalTime from 'local-time'
// import 'trix'
// import '@rails/actiontext'
import 'alpine-turbo-drive-adapter'
import "alpinejs"
import 'vite/dynamic-import-polyfill'

ActiveStorage.start()
LocalTime.start()

import { Application } from 'stimulus'
import { registerControllers } from 'stimulus-vite-helpers'

const application = Application.start()
import consumer from '../channels/consumer'
application.consumer = consumer
const controllers = import.meta.globEager('../controllers/**/*_controller.js')
const componentsControllers = import.meta.globEager('../../components/**/*_controller.js')
registerControllers(application, controllers)
registerControllers(application, componentsControllers)
import "@hotwired/turbo-rails"
Turbo.navigator.view.snapshotCache.size = 20
const channels = import.meta.globEager('../channels/**/*_channel.js')
import StimulusReflex from 'stimulus_reflex'
import StimulusController from '../controllers/application_controller'
import { Alert } from "tailwindcss-stimulus-components"
application.register('alert', Alert)
StimulusReflex.initialize(application, { StimulusController, isolate: true })
StimulusReflex.debug = import.meta.env.MODE === 'development'

