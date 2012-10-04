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
      speed: 250
    };

    /* initiator
    ======================
    */


    dTab.prototype.init = function() {
      this.opts = $.extend({}, this.defaults, this.opts, this.meta);
      this.width = this.opts.width ? this.opts.width : this.util.getLargest(this.tabs, 'width');
      return this.height = this.opts.height ? this.opts.height : this.util.getLargest(this.tabs, 'height');
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
        return $(this).replaceWith('<li><span class="text">' + $(this).html() + '</span></li>');
      });
      this.tabs.prependTo(this.el.find('.container'));
      if (this.opts['lock'] || (this.opts['fx'] !== 'none' && this.opts['fx'] !== 'fade')) {
        this.el.find('.container').css({
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
          var totalWidth;
          totalWidth = obj.width * obj.tabs.length;
          obj.el.find('.container').wrapInner('<div class="js-tab-full-size" style="width: ' + totalWidth + 'px; height:' + obj.height + 'px" />');
          obj.tabs.css({
            float: 'left'
          });
          return obj.el.on('paging', function(evt, param) {
            return obj.el.find('.js-tab-full-size').animate({
              'margin-left': param['back'] + (param['diff'] * obj.width)
            });
          });
        },
        slideY: function() {
          var totalHeight;
          totalHeight = obj.height * obj.tabs.length;
          obj.el.find('.container').wrapInner('<div class="js-tab-full-size" style="width: ' + obj.width + 'px; height:' + totalHeight + 'px" />');
          return obj.el.on('paging', function(evt, param) {
            return obj.el.find('.js-tab-full-size').animate({
              'margin-top': param['back'] + (param['diff'] * obj.height)
            });
          });
        }
      };
      return effects[fx]();
    };

    /* utility
    =================
    */


    dTab.prototype.util = {
      findDiff: function() {
        var num;
        num = arguments[0] - arguments[1];
        return {
          diff: Math.abs(num),
          back: num < 0 ? '-=' : '+='
        };
      },
      setActive: function(el) {
        return $(el).addClass('active').siblings().removeClass('active');
      },
      getLargest: function(el, d) {
        var size;
        size = [];
        el.each(function() {
          return size.push($(this)[d]());
        });
        return Math.max.apply(this, size);
      }
    };

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
      /* Prevent re-initialize
      */

      if ($(this).hasClass('js-init')) {
        return false;
      }
      $(this).addClass('js-init');
      D = new dCache['dTab'](this, options);
      D.init();
      D.log(D);
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
        var diff;
        if ($(this).hasClass('active')) {
          return false;
        }
        diff = D.util.findDiff(self.find('.active').index(), $(this).index());
        self.trigger('paging', {
          i: $(this).index(),
          inSpeed: !D.opts.inSpeed ? D.opts.speed : void 0,
          outSpeed: !D.opts.outSpeed ? D.opts.speed : void 0,
          diff: diff.diff,
          back: diff.back
        });
        return D.util.setActive(this);
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
