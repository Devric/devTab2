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
      trigger  : 'click'


    ### initiator
    ====================== ###
    # @defaults : class options
    # @opts     : plugin options
    # @meta     : dom-data options
    init: ->
      @opts = $.extend {}, @defaults, @opts, @meta
      @width  = if @opts.width  then @opts.width  else @util.getLargest(@tabs, 'width')
      @height = if @opts.height then @opts.height else @util.getLargest(@tabs, 'height')


    ###  builder
    ================= ###
    build: (obj) ->

      # create containers
      #
      #
      # creating containers
      # to wrap tabs and menu
      # @if menu-bot, create append
      # @if menu-both, create both
      # @else menu, create prepend
      # ==================
      @el.prepend('<div class="container" />')


      # menu, nav, pager
      #
      #
      #===================

      ### Menu
      ###
      menu = '<ul class="menu" />'
      if @opts['menu'] then @el.append(menu) else @el.prepend(menu)

      title = @tabs.find('.title')
      title.prependTo( @el.find('.menu') )

      ### nav
      ###
      nav = '<ul class="nav">'

      if @opts['navPosition']
        switch @opts['nav']
          when 'both'
            @el.find('.container').before(nav)
            @el.find('.container').after(nav)
          when 'bot'
            @el.find('.container').after(nav)
      else
        @el.find('.container').before(nav)

      ### Pager
      ###
      if @opts['pager']
        i = @tabs.length + 1
        while i -= 1
          @el.find('.nav').prepend('<li class="pager">' + i + '</li>')

      # prev, next
      if @opts['nav']
        @el.find('.nav').prepend('<li class="prev">prev</li>')
        @el.find('.nav').append('<li class="next">next</li>')

      # Push el into container
      #
      #
      # ===================
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
      @el.find('.menu').children().first().addClass('active')
      @el.find('.pager').first().addClass('active')
      @el.find('.prev').addClass('disable')



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

      setDisable: () ->
        # @todo set disable nav, if eq = 0 or eq = length-1

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
(($, window) ->
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

      ### Trigger : menu 
      ###
      self.on D.opts.trigger, '.menu li', ->
        if $(this).hasClass('active')
          return false

        # find index differnce and direction
        diff = D.util.findDiff( self.find('.menu .active').index(), $(@).index() )
        
        # trigger effects
        self.trigger 'paging', {
            i: $(@).index()
            inSpeed  : if !D.opts.inSpeed then D.opts.speed
            outSpeed : if !D.opts.outSpeed then D.opts.speed
            diff     : diff.diff
            back     : diff.back
        }

        # add active class to menu
        D.util.setActive(this)

        # pager
        D.util.setActive( self.find('.pager').eq( $(@).index() ) )

        # disable
        if self.find('.menu .active').index() == 0
          self.find('.next, .prev').removeClass('disable')
          self.find('.prev').addClass('disable')
        else if self.find('.menu .active').index() == self.find('.menu li').length-1
          self.find('.next, .prev').removeClass('disable')
          self.find('.next').addClass('disable')
        else
          self.find('.next, .prev').removeClass('disable')


      ### Trigger : nav 
      ###
      self.on 'click', '.prev', ->
        if self.find('.menu .active').index() != 0
          self.find('.menu .active').prev().trigger('click')

      self.on 'click', '.next', ->
        if self.find('.menu .active').index() != self.find('.menu li').length-1
          self.find('.menu .active').next().trigger('click')

      ### Trigger: pager
      ###
      self.on 'click', '.pager', ->
        self.find('.menu li').eq( $(this).index()-1 ).trigger 'click'

      # history

      # responsive

)(jQuery, window)

### ============== AUTO RUN DEFAULT ============= ###
### =================================================
 Any new methods will require re-initiate the plugin
================================================= ###
$ -> 
    $('.dtab').devTab({debug:true});
