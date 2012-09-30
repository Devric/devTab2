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
      @el   = $(el)      # $itself
      @opts = opts       # $(el).plugin( opts )
      @meta = @el.data() # allow inline

      @id     = @el.attr('id')
      @tabs   = @el.find('.tabs')
      @width  = @tabs.outerWidth(true)
      @height = @tabs.outerHeight(true)

    log: (msg) -> console?.log msg if @opts.debug # Simplify logger() ***STRIP***


    ### plugin default options 
    ====================== ###
    defaults:
      'lock' : false
      fx            : 'none'
      debug         : false


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

      @log 'set: ' + obj['width']
      @log 'set: ' + obj['height']
      @log '============'

      @log 'auto: ' + @weight
      @log 'auto: ' + @height
      @log '============'

      # create navs
      # ===================
      @el.prepend('<ul class="nav" />')
      @el.find('.tabs').find('.title').prependTo( @el.find('.nav') )

      # @if
      # fx is not fade || none
      #
      #
      # Lock dimension to keep same size container and tab
      # ===================
      if @opts['fx'] != 'fade' || @opts['fx'] != 'none' || @opts['lock'] 

        # container style
        # ===================
        @el.css
          overflow: 'hidden'
          width  : (if obj['width']  then obj['width']  else @width)
          height : (if obj['height'] then obj['height'] else @height)

        # tab style
        # ===================
        @tabs.css
          width  : (if obj['width']  then obj['width']  else @width)
          height : (if obj['height'] then obj['height'] else @height)

      else
        # @else
        # fx is fade or none and not locked height
        #
        # hide divs if is fade and null
        # ===================
        @tabs.not(':first').css
            display: 'none'



    ### FX
    ================= ###
    fx: (fx) ->
      # save @obj instance
      obj = @

      # set fx to default if !fx
      fx = 'none' if !fx || fx ==  null

      effects = 
        none : ->
          console.log 'detault'

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
  pluginName                    = 'devTab'
  plugin[ pluginName ]          = '0.1.0Dead simple tabs with slideshows'
  plugin[ pluginName + '_url']  = 'devric.co.cc'

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
