import ApplicationController from './application_controller'
import {debounce} from "lodash"
/* This is the custom StimulusReflex controller for the Search Reflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  static targets = ['query', 'dbMode', 'regexMode', 'activity', 'count', 'list']

  connect() {
    super.connect()
    this.perform = debounce(this.perform, 500).bind(this)
    this.gotoPage = debounce(this.gotoPage, 1000).bind(this)
  }

  beforePerform(element, reflex) {
    this.activityTarget.classList.remove("hidden")
    this.countTarget.hidden = true
  }

  perform(event, page = 1) {
    event.preventDefault()
    this.stimulate('SearchReflex#perform', {
      query: this.queryTarget.value,
      page: page,
      db_mode: this.dbModeTarget.checked,
      regex_mode: this.regexModeTarget.checked
    })
  }

  modeCheck() {
    this.regexModeTarget.disabled = this.dbModeTarget.checked !== true;
  }

  nextPage(event) {
    event.preventDefault()
    this.perform(event, event.target.dataset.page)
  }

  gotoPage(event) {
    event.preventDefault()
    this.perform(event, event.target.value)
  }

  /* Reflex specific lifecycle methods.
   *
   * For every method defined in your Reflex class, a matching set of lifecycle methods become available
   * in this javascript controller. These are optional, so feel free to delete these stubs if you don't
   * need them.
   *
   * Important:
   * Make sure to add data-controller="search" to your markup alongside
   * data-reflex="Search#dance" for the lifecycle methods to fire properly.
   *
   * Example:
   *
   *   <a href="#" data-reflex="click->Search#dance" data-controller="search">Dance!</a>
   *
   * Arguments:
   *
   *   element - the element that triggered the reflex
   *             may be different than the Stimulus controller's this.element
   *
   *   reflex - the name of the reflex e.g. "Search#dance"
   *
   *   error/noop - the error message (for reflexError), otherwise null
   *
   *   reflexId - a UUID4 or developer-provided unique identifier for each Reflex
   */

  // Assuming you create a "Search#dance" action in your Reflex class
  // you'll be able to use the following lifecycle methods:

  // beforeDance(element, reflex, noop, reflexId) {
  //  element.innerText = 'Putting dance shoes on...'
  // }

  // danceSuccess(element, reflex, noop, reflexId) {
  //   element.innerText = '\nDanced like no one was watching! Was someone watching?'
  // }

  // danceError(element, reflex, error, reflexId) {
  //   console.error('danceError', error);
  //   element.innerText = "\nCouldn\'t dance!"
  // }

  // afterDance(element, reflex, noop, reflexId) {
  //   element.innerText = '\nWhatever that was, it\'s over now.'
  // }

  // finalizeDance(element, reflex, noop, reflexId) {
  //   element.innerText = '\nNow, the cleanup can begin!'
  // }
}
