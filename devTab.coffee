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


    log: (msg) -> console?.log msg if @opts.debug # Simplify logger()


    ### plugin default options 
    ====================== ###
    defaults:
      debug  : false
      fx     : 'none'
      'lock' : false
      timer  : false
      inSpeed  : false
      outSpeed : false
      speed    : 250


    ### initiator
    ====================== ###
    # @defaults : class options
    # @opts     : plugin options
    # @meta     : dom-data options
    init: ->
      @opts = $.extend {}, @defaults, @opts, @meta
      @width  = if @opts.width then @opts.width else @util.getLargest(@tabs, 'width')
      @height = if @opts.height then @opts.height else @util.getLargest(@tabs, 'height')


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
        $(this).replaceWith '<li><span class="text">' + $(this).html() + '</span></li>'

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

      
      # Active class
      # Select the first on start
      #
      # ===================
      @el.find('.nav').children().first().addClass('active')


    ### FX
    ================= ###
    # @todo: refactor this function to just object literal
    fx: (fx) ->
      # save @obj instance
      obj = @

      # set fx to default if !fx
      fx = 'none' if !fx

      effects = 
        none : ->
          obj.el.on 'paging', (evt, param) ->
            # hide all other tabs
            obj.el.find('.tab').hide()

            # show tab i
            obj.el.find('.tab').eq(param['i']).show()


        fade : ->
          obj.el.on 'paging', (evt, param) ->
            # hide and show tags
            obj.el.find('.tab').fadeOut(param['outSpeed']).promise().done ->
              obj.el.find('.tab').eq(param['i']).fadeIn(param['inSpeed'])


        slideX : ->
          # build for this fx
          totalWidth = obj.width * obj.tabs.length
          obj.el.find('.container').wrapInner('<div class="js-tab-full-size" style="width: ' + totalWidth + 'px; height:' + obj.height + 'px" />')

          obj.tabs.css
            float: 'left'

          # event action
          obj.el.on 'paging', (evt, param) ->
            obj.el.find('.js-tab-full-size').animate
              # param['back'] returns -= || +=
              'margin-left': param['back'] + ( param['diff'] * obj.width )


        slideY : ->
          # build for this fx
          totalHeight = obj.height * obj.tabs.length
          obj.el.find('.container').wrapInner('<div class="js-tab-full-size" style="width: ' + obj.width + 'px; height:' + totalHeight + 'px" />')

          # event action
          obj.el.on 'paging', (evt, param) ->
            obj.el.find('.js-tab-full-size').animate
              # param['back'] returns -= || +=
              'margin-top': param['back'] + ( param['diff'] * obj.height )


      effects[fx]()
    

    ### utility
    ================= ###
    util:
      # @return integer
      # @return boolean
      findDiff: ->
        num = arguments[0] - arguments[1]
        diff: Math.abs(num)
        back: if ( num < 0 ) then '-=' else '+='

      # @return function
      setActive: (el) ->
        $(el).addClass('active')
             .siblings()
             .removeClass('active')

      # @return integer
      getLargest : (el,d) ->
        size = []
        el.each ->
          size.push $(this)[d]()

        return Math.max.apply(this, size)




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
      self = $(this)

      ### Prevent re-initialize
      ### # so that new method initialize won't affect the old
      if $(this).hasClass('js-init')
        return false
      $(this).addClass('js-init')


      D = new dCache['dTab'](this, options)
      D.init()

      D.log D

      ### build it 
      ###
      D.build({
          width: D.opts.width
          height: D.opts.height
      })

      ### Effects
          if no effects options, use default ###
      if D.opts.fx then D.fx(D.opts.fx) else D.fx()

      ### Trigger ###
      self.on 'click', '.nav li', ->
        if $(this).hasClass('active')
          return false

        # find index differnce and direction
        diff = D.util.findDiff( self.find('.active').index(), $(@).index() )
        
        # trigger effects
        self.trigger 'paging', {
            i: $(@).index()
            inSpeed  : if !D.opts.inSpeed then D.opts.speed
            outSpeed : if !D.opts.outSpeed then D.opts.speed
            diff     : diff.diff
            back     : diff.back
        }

        # add active class
        D.util.setActive(this)
        


      # history

      # responsive

)(jQuery, window)

### ============== AUTO RUN DEFAULT ============= ###
### =================================================
 Any new methods will require re-initiate the plugin
================================================= ###
$ -> 
    $('.dtab').devTab({debug:true});
