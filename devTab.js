// Generated by CoffeeScript 1.3.3
/*   dCache for all devric plugins
*/

if (window.dCache === void 0) {
  window.dCache = {};
}

/* ===========================
  Plugin Class
==============================
*/


(function($, window) {
  /* Plugin class
  */

  var dTab;
  dTab = (function() {
    /* default elements
    ======================
    */

    function dTab(el, opts) {
      /* Assign
      */
      this.el = $(el);
      this.opts = opts;
      this.meta = this.el.data();
      this.id = this.el.attr('id');
      this.tabs = this.el.find('.tab');
      this.title = this.tabs.find('.title');
      this.width = this.tabs.outerWidth(true);
      this.height = this.tabs.outerHeight(true);
    }

    dTab.prototype.log = function(msg) {
      if (this.opts.debug) {
        return typeof console !== "undefined" && console !== null ? console.log(msg) : void 0;
      }
    };

    /* plugin default options 
    ======================
    */


    dTab.prototype.defaults = {
      debug: false,
      fx: 'none',
      'lock': false,
      timer: false,
      inSpeed: false,
      outSpeed: false,
      speed: 'slow'
    };

    /* initiator
    ======================
    */


    dTab.prototype.init = function() {
      return this.opts = $.extend({}, this.defaults, this.opts, this.meta);
    };

    /*  builder
    =================
    */


    dTab.prototype.build = function(obj) {
      var nav, title;
      this.el.prepend('<div class="container" />');
      nav = '<ul class="nav" />';
      switch (this.opts['nav']) {
        case 'bot':
          this.el.append(nav);
          break;
        case 'both':
          this.el.append(nav);
          this.el.prepend(nav);
          break;
        default:
          this.el.prepend(nav);
      }
      title = this.tabs.find('.title');
      title.prependTo(this.el.find('.nav'));
      title.each(function() {
        return $(this).replaceWith('<li>' + $(this).html() + '</li>');
      });
      this.tabs.prependTo(this.el.find('.container'));
      if (this.opts['lock'] || (this.opts['fx'] !== 'none' && this.opts['fx'] !== 'fade')) {
        this.el.find('.container').css({
          background: 'blue',
          overflow: 'hidden',
          width: (obj['width'] ? obj['width'] : this.width),
          height: (obj['height'] ? obj['height'] : this.height)
        });
        this.tabs.css({
          overflow: 'hidden',
          width: (obj['width'] ? obj['width'] : this.width),
          height: (obj['height'] ? obj['height'] : this.height)
        });
      }
      if (this.opts['fx'] === 'none' || this.opts['fx'] === 'fade') {
        this.tabs.not(':first').css({
          display: 'none'
        });
      }
      return this.el.find('.nav').children().first().addClass('active');
    };

    /* FX
    =================
    */


    dTab.prototype.fx = function(fx) {
      var effects, obj;
      obj = this;
      if (!fx) {
        fx = 'none';
      }
      effects = {
        none: function() {
          return obj.el.on('paging', function(evt, param) {
            obj.el.find('.tab').hide();
            return obj.el.find('.tab').eq(param['i']).show();
          });
        },
        fade: function() {
          return obj.el.on('paging', function(evt, param) {
            return obj.el.find('.tab').fadeOut(param['outSpeed']).promise().done(function() {
              return obj.el.find('.tab').eq(param['i']).fadeIn(param['inSpeed']);
            });
          });
        },
        slideX: function() {
          return obj.el.on('paging', function(evt, param) {
            console.log(param);
            return console.log('slideX');
          });
        },
        slideY: function() {
          return obj.el.on('paging', function(evt, param) {
            console.log(param);
            return console.log('slideY');
          });
        }
      };
      return effects[fx]();
    };

    /* utility
    =================
    */


    return dTab;

  })();
  /* == Exports =============
  */

  return dCache['dTab'] = dTab;
})(jQuery, window);

/* ===========================
  Jquery Plugin Interface
==============================
*/


(function($, window) {
  var pluginName;
  if (window.plugin === void 0) {
    window.plugin = {};
  }
  pluginName = 'devTab';
  plugin[pluginName] = '0.1.0Dead simple tabs with slideshows';
  plugin[pluginName + '_url'] = 'devric.co.cc';
  /* Adds plugin object to jQuery
  */

  return $.fn[pluginName] = function(options) {
    return this.each(function() {
      var D, self;
      self = $(this);
      D = new dCache['dTab'](this, options);
      D.init();
      D.log(D.opts);
      /* build it
      */

      D.build({
        width: D.opts.width,
        height: D.opts.height
      });
      /* Effects
          if no effects options, use default
      */

      if (D.opts.fx) {
        D.fx(D.opts.fx);
      } else {
        D.fx();
      }
      /* Trigger
      */

      return self.on('click', '.nav li', function() {
        if ($(this).hasClass('active')) {
          return false;
        }
        $(this).addClass('active').siblings().removeClass('active');
        return self.trigger('paging', {
          i: $(this).index(),
          inSpeed: !D.opts.inSpeed ? D.opts.speed : void 0,
          outSpeed: !D.opts.outSpeed ? D.opts.speed : void 0
        });
      });
    });
  };
})(jQuery, window);

/* ============== AUTO RUN DEFAULT =============
*/


/* =================================================
 Any new methods will require re-initiate the plugin
=================================================
*/


$(function() {
  return $('.dtab').devTab({
    debug: true
  });
});
