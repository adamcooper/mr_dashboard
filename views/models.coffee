class Page
  settings: {}

  constructor: (settings) ->
    for name, value in settings
      this.settings[name] = value

  setup: () ->
    if !loaded_setup
      template = $('div.template iframe')
      @iframe = template.dup()
    end

class Rotator

  constructor: (active_container, pending_container) ->
    @active_container = $(active_container)
    @pending_container = $(pending_container)
    @high_priority_queue = []
    @frame_queue = []
    @frame_counter = 0

  # This will add page to the priority queue for a short duration
  add_flash_page: (page) ->
    @high_priority_queue.push(page)

  # this will add page to long term rotation queue
  add_page: (page) ->
    @frame_queue.push(page)

  start: () ->
    rotate

  display_new_page: (new_page) ->
    @pending << @active
    @pending_container.append(@active.frame)

    @acive = new_page
    @active_container.html(new_page.frame)
    rotate_to(next_pending,
end
