
# get the top level object
root = exports ? this
$ = jQuery


class Queue

  constructor: () ->
    @queue = []
    @offset = 0

  enqueue: (item) =>
    @queue.push(item)

  dequeue: () =>
    return null if @queue.length == 0

    item = @queue[@offset]

    # free up space if need be
    if ++@offset * 2 >= @queue.length
      @queue = @queue.slice(@offset)
      @offset = 0

    return item

  length: =>
    @queue.length - @offset

  peek: =>
    @queue[@offset]

class SiteList

  constructor: () ->
    @items = []
    @counter = 0

  add: (item) ->
    @items.push(item)

  each: (fnct) ->
   fnct(item) for item in @items

  next: ->
    @counter++
    @counter = 0 if @counter >= @items.length
    @items[@counter]

# This manages the displaying of pages
class DisplayList

  constructor: () ->
    @sites = new SiteList()
    @pages = new Queue()

  add_site: (item) ->
    @sites.add(item)

  add_page: (item) ->
    @pages.enqueue(item)

  fetch: ->
    item = @pages.dequeue()
    item = @sites.next() if item == null

class Page

  constructor: (@url, @duration) ->

  # Appends the page's html to the container
  #
  # This will only append the html once
  append_to: (container) =>
    container.append(this.element())

  show: =>
    this.element().show()

  hide: =>
    this.element().hide()

  # Returns the element
  element: ()->
    if !@internal_element?
      @internal_element = $("<iframe border='0' frameborder='0' framespacing='0' marginheight='0' marginwidth='0' name='frame' scrolling='yes'></iframe>").
        attr(src: @url, style: 'display: none')

    @internal_element


# Rotator: handles the logic related to controlling the rotation
#
# This rotator should be notified if you wish to pause, skip or in general control the
# rotation.
#
class Rotator
  constructor: (container, sites, speed) ->
    @container = $(container)
    @current_speed = speed
    @display_list = new DisplayList

    for site in sites
      @display_list.add_site(site)
      site.append_to(@container)

    @paused = false
    @current_page = sites[0]
    @current_page.show()

  pause: =>
    @paused = true

  play: =>
    return unless @paused

    @paused = false
    this.perform()

  perform: () =>
    return if @paused

    next_page = @display_list.fetch()

    @current_page.hide()
    next_page.show()
    @current_page = next_page

    setTimeout(this.perform, next_page.duration) if next_page.duration > 0

  set_site_speed: (speed) =>
    @current_speed = speed
    @display_list.sites.each (site) ->
      site.duration = speed



$ ->
  $.getJSON '/settings.js', (data)->

    # setting up rotator and pages
    sites = (new Page(url, data['speed']) for url in data['sites'] )
    root.sites = sites
    root.display = DisplayList
    rotator = new Rotator($('#frame_container'), sites, data['speed'])
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

    $('#speed').click ->
      speed = parseInt(prompt("The current speed is #{rotator.current_speed / 1000} seconds.\n\nPlease enter the new speed in secods:")) * 1000
      rotator.set_site_speed(speed) if speed?

    # debugging exports
    root.page = Page
    root.rotator = rotator
