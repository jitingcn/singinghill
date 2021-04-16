// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log('Vite ⚡️ Rails')
import '~/stylesheets/application.css'

import Rails from "@rails/ujs"
try { Rails.start() } catch { }

import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import LocalTime from 'local-time'
import.meta.globEager('../channels/**/*_channel.js')
// import 'trix'
// import '@rails/actiontext'
import 'alpine-turbo-drive-adapter'
import "alpinejs"
import '@hotwired/turbo-rails'
import { Turbo, cable } from "@hotwired/turbo-rails"
window.Turbo = Turbo
import 'vite/dynamic-import-polyfill'

ActiveStorage.start()
LocalTime.start()

import { Application } from 'stimulus'
import { registerControllers } from 'stimulus-vite-helpers'

const application = Application.start()
const controllers = import.meta.globEager('../controllers/**/*_controller.js')
const componentsControllers = import.meta.globEager('../../components/**/*_controller.js')
registerControllers(application, controllers)
registerControllers(application, componentsControllers)

import StimulusReflex from 'stimulus_reflex'
import consumer from '../channels/consumer'
application.consumer = consumer
import StimulusController from '../controllers/application_controller'
StimulusReflex.initialize(application, { consumer, StimulusController, isolate: true })
StimulusReflex.debug = import.meta.env.MODE === 'development'

window.addEventListener('load', () => {
  if (navigator.serviceWorker) {
    navigator.serviceWorker.register('/service-worker.js', { scope: './' })
      .then(function(reg) {
        console.log('[Companion]', 'Service worker registered!');
        console.log(reg);
      }).catch(registrationError => {
        console.log('Service worker registration failed: ', registrationError);
      });
  }
})
