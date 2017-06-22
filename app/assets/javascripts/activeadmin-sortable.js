(function($) {
  $(document).on('ready page:load turbolinks:load', function(){
    $('.handle').closest('tbody').activeAdminSortable();
  });

  $.fn.activeAdminSortable = function() {
    this.sortable({
      update: function(event, ui) {
        var url = ui.item.find('[data-sort-url]').data('sort-url');

        $.ajax({
          url: url,
          type: 'post',
          data: {
            position: ui.item.index() + 1,
            prev_position: ui.item.prev().find('[data-position]').data('position'),
            next_position: ui.item.next().find('[data-position]').data('position')
          },
          success: function() { window.location.reload() }
        });
      }
    });

    this.disableSelection();
  }
})(jQuery);
