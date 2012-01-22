
# get the top level object
root = exports ? this
$ = jQuery


class Queue

  constructor: () ->
    @items = []
    @counter = 0

  add: (item) ->
    @items.push(item)

  current: ->
    @items[@counter]

  next: ->
    @counter++
    @counter = 0 if @counter >= @items.length
    @items[@counter]

class Page

  @settings:
    rotation_speed: 15000;

  @build: (url) =>
    new Page(url, this.settings.rotation_speed)

  constructor: (@url, @duration) ->

  element: () ->
    if !@internal_element
      @internal_element = $("<iframe border='0' frameborder='0' framespacing='0' marginheight='0' marginwidth='0' name='frame' scrolling='yes'></iframe>").
        attr(src: @url, style: 'display: none')

    @internal_element

  show: ->
    @internal_element.show();

  hide: ->
    @internal_element.hide();


# Rotator: handles the logic related to controlling the rotation
#
# This rotator should be notified if you wish to pause, skip or in general control the
# rotation.
#
class Rotator
  constructor: (container, queue) ->
    @container = $(container)
    @queue = queue
    @paused = false
    @container.append(page.element()) for page in @queue.items
    @current_page = queue.current()

  pause: ->
    @paused = true

  play: =>
    return unless @paused

    @paused = false
    this.perform()

  perform: () =>
    return if @paused

    next_page = @queue.next()

    @current_page.hide()
    next_page.show()
    @current_page = next_page

    setTimeout(this.perform, next_page.duration) if next_page.duration > 0

pages =['http://www.partnerpedia.com', 'https://marketplace.cisco.com'];

$ ->
  # setting up rotator and pages
  queue = new Queue()
  queue.add(Page.build(url)) for url in pages
  rotator = new Rotator($('#frame_container'), queue)
  rotator.perform()


  # bind handlers
  play_btn = $('#play')
  pause_btn = $('#pause')

  play_btn.click ->
    pause_btn.show()
    play_btn.hide()
    rotator.play()

  pause_btn.click ->
    pause_btn.hide()
    play_btn.show()
    rotator.pause()

  # debugging exports
  root.page = Page
  root.rotator = rotator
  root.queue = queue
