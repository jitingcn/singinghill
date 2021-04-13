import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

const application = Application.start()
const context = require.context("controllers", true, /_controller\.js$/)
const contextComponents = require.context("../components", true, /_controller\.js$/)

application.load(
    definitionsFromContext(context).concat(
        definitionsFromContext(contextComponents)
    )
)

import StimulusReflex from 'stimulus_reflex'
import consumer from 'channels/consumer'
import controller from 'controllers/application_controller'
StimulusReflex.initialize(application, { consumer, controller, isolate: true })
StimulusReflex.debug = import.meta.env.MODE === 'development'
