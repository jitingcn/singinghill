if (import.meta.env.MODE !== 'development') {
  import('vite/modulepreload-polyfill')
}

import '~/stylesheets/application.css'

import mrujs from "mrujs"
import * as ActiveStorage from "@rails/activestorage"
import LocalTime from 'local-time'
// import 'trix'
// import '@rails/actiontext'
import 'alpine-turbo-drive-adapter'
import "alpinejs"

ActiveStorage.start()
LocalTime.start()

import "@stimulus_reflex/polyfills"
import { Application } from '@hotwired/stimulus'
import { registerControllers } from 'stimulus-vite-helpers'

const application = Application.start()
import consumer from '../channels/consumer'
application.consumer = consumer
const controllers = import.meta.globEager('../controllers/**/*_controller.js')
const componentsControllers = import.meta.globEager('../../components/**/*_controller.js')
registerControllers(application, controllers)
registerControllers(application, componentsControllers)
import { Turbo, cable } from "@hotwired/turbo-rails"
Turbo.navigator.view.snapshotCache.size = 20
const channels = import.meta.globEager('../channels/**/*_channel.js')
import StimulusReflex from 'stimulus_reflex'
import StimulusController from '../controllers/application_controller'
import { Alert, Dropdown, Modal } from "tailwindcss-stimulus-components"
application.register('alert', Alert)
application.register('dropdown', Dropdown)
application.register('modal', Modal)
StimulusReflex.initialize(application, { StimulusController, isolate: true })
StimulusReflex.debug = import.meta.env.MODE === 'development'
window.Turbo = Turbo
Turbo.start()
mrujs.start()
