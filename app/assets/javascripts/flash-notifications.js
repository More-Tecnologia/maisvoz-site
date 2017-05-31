jQuery(document).ready(function() {

  function FlashNotifications($el) {
    this.title = $el.data('title')
    this.key = $el.data('key') || 'info'
    this.text = $el.data('text')
  }

  FlashNotifications.prototype.init = function() {
    var style = this.key
    var position = 'top right'
    var icon = "fa fa-adjust";
    if(style == "error"){
        icon = "fa fa-exclamation";
    }else if(style == "warning"){
        icon = "fa fa-warning";
    }else if(style == "success"){
        icon = "fa fa-check";
    }else if(style == "custom"){
        icon = "md md-album";
    }else if(style == "info"){
        icon = "fa fa-question";
    }else{
        icon = "fa fa-adjust";
    }
    $.notify({
        title: this.title,
        text: this.text,
        image: "<i class='"+icon+"'></i>"
    }, {
        style: 'metro',
        className: style,
        globalPosition:position,
        showAnimation: "show",
        showDuration: 0,
        hideDuration: 0,
        autoHideDelay: 5000,
        autoHide: true,
        clickToHide: true
    });
  }

  $('[data-notification]').each(function(i, el) {
    var $el = $(el)
    new FlashNotifications($el).init()
  })

})
