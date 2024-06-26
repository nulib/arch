//= require jquery.treetable
//= require browse_everything/behavior

// Show the files in the queue
$( document ).ready(function() {
  // We need to check this because https://github.com/samvera/browse-everything/issues/169
  if ($('#browse-btn').length > 0) {
    $('#browse-btn').browseEverything()
    .done(function(data) {
      var evt = { isDefaultPrevented: function() { return false; } };
      var files = $.map(data, function(d) { return { name: d.url.split('?')[0].split('/').pop(), size: d.file_size, id: d.url } });
      $.blueimp.fileupload.prototype.options.done.call($('#fileupload').fileupload(), evt, { result: { files: files }});
    })
  }
});
