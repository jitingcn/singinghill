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

// async function loadBridgeControllers() {
//   const { definitions } = await import(/* webpackChunkName: "bridge" */ "bridge")
//   application.load(definitions)
// }
