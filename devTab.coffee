# ===================================== #
###   dCache for all devric plugins   ###
# ===================================== #
window.dCache = {} if window.dCache == undefined


### ===========================
  Plugin Class
============================== ###
(($, window)->
  ### Plugin class ###
  class dTab

    ### default elements
    ====================== ###
    constructor: (el, opts)->
      ### Assign ###
      @el   = $(el)      # $itself
      @opts = opts       # $(el).plugin( opts )
      @meta = @el.data() # allow inline

      @id     = @el.attr('id')
      @tabs   = @el.find('.tab')
      @title  = @tabs.find('.title')
      @width  = @tabs.outerWidth(true)
      @height = @tabs.outerHeight(true)

      ### Trigger ###
      $($(el)).on 'click', '.nav li', ->
        console.log $(@).closest($(el))
        console.log $(@).index()
      

    log: (msg) -> console?.log msg if @opts.debug # Simplify logger()


    ### plugin default options 
    ====================== ###
    defaults:
      debug  : false
      fx     : 'none'
      'lock' : false


    ### initiator
    ====================== ###
    # @defaults : class options
    # @opts     : plugin options
    # @meta     : dom-data options
    init: ->
      @opts = $.extend {}, @defaults, @opts, @meta


    ###  builder
    ================= ###
    build: (obj) ->

      # create containers
      #
      #
      # creating containers
      # to wrap tabs and nav
      # @if nav-bot, create append
      # @if nav-both, create both
      # @else nav, create prepend
      # ==================
      @el.prepend('<div class="container" />')

      nav = '<ul class="nav" />'

      switch @opts['nav']
        when 'bot'
          @el.append(nav)
        when 'both'
          @el.append(nav)
          @el.prepend(nav)
        else
          @el.prepend(nav)


      # Push el into container
      #
      #
      # ===================
      title = @tabs.find('.title')
      title.prependTo( @el.find('.nav') )

      # change to li
      title.each ->
        $(this).replaceWith '<li>' + $(this).html() + '</li>'

      @tabs.prependTo( @el.find('.container') )


      # Build dimension
      # @if
      # fx is not fade || none and lock
      #
      # Lock dimension to keep same size container and tab
      # ===================

      if @opts['lock'] || ( @opts['fx'] != 'none' and @opts['fx'] != 'fade' )
        # container style
        # ===================
        @el.find('.container').css
          background: 'blue'
          overflow: 'hidden'
          width  : (if obj['width']  then obj['width']  else @width)
          height : (if obj['height'] then obj['height'] else @height)
            

        # tab style
        # ===================
        @tabs.css
          overflow: 'hidden'
          width  : (if obj['width']  then obj['width']  else @width)
          height : (if obj['height'] then obj['height'] else @height)

      
      # @if
      # fx == fade || none
      # just hide none first
      #
      # ===================
      if @opts['fx'] == 'none' || @opts['fx'] == 'fade'
        @tabs.not(':first').css
            display: 'none'


    ### FX
    ================= ###
    fx: (fx) ->
      # save @obj instance
      obj = @

      # set fx to default if !fx
      fx = 'none' if !fx

      effects = 
        none : ->
          console.log 'default'

        fade : ->
          console.log 'fade'

        slideX : ->
          console.log 'slideX'

        slideY : ->
          console.log 'slideY'

      effects[fx]()
    


  ### == Exports ============= ###
  dCache['dTab'] = dTab

)(jQuery, window)


### ===========================
  Jquery Plugin Interface
============================== ###
(($, window)->
  if window.plugin == undefined 
    window.plugin = {}
  pluginName                   = 'devTab'
  plugin[ pluginName ]         = '0.1.0Dead simple tabs with slideshows'
  plugin[ pluginName + '_url'] = 'devric.co.cc'

  ### Adds plugin object to jQuery ###
  $.fn[ pluginName ] = (options) ->
    return @each ()->
      D = new dCache['dTab'](this, options)
      D.init()

      ### build it 
      ###
      D.build({
          width: D.opts.width
          height: D.opts.height
      })

      ### Effects
          if no effects options, use default ###
      if D.opts.fx then D.fx(D.opts.fx) else D.fx()

      D.log D.opts

      # pager
    
      # history

      # responsive

)(jQuery, window)

### ============== AUTO RUN DEFAULT ============= ###
### =================================================
 Any new methods will require re-initiate the plugin
================================================= ###
$ -> 
    $('.dtab').devTab({test:'something', debug:true});
