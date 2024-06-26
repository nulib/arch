//= require fileupload/tmpl
//= require fileupload/jquery.iframe-transport
//= require fileupload/jquery.fileupload.js
//= require fileupload/jquery.fileupload-process.js
//= require fileupload/jquery.fileupload-validate.js
//= require fileupload/jquery.fileupload-ui.js
//
/*
 * jQuery File Upload Plugin JS Example
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */
/*
 * This file overriden from Hyrax to override maxNumberOfFiles:
 * https://github.com/samvera/hyrax/blob/v1.0.4/app/assets/javascripts/hyrax/uploader.js
 * Remove this file during 2.0 upgrade
 * These settings are configurable in the initialzier in Hyrax 2
 * https://github.com/samvera/hyrax/blob/master/lib/hyrax/configuration.rb#L523
 */

(function ($) {
  "use strict";

  $.fn.extend({
    hyraxUploader: function (options) {
      // Initialize our jQuery File Upload widget.
      // TODO: get these values from configuration.
      this.fileupload(
        $.extend(
          {
            // xhrFields: {withCredentials: true},              // to send cross-domain cookies
            // acceptFileTypes: /(\.|\/)(png|mov|jpe?g|pdf)$/i, // not a strong check, just a regex on the filename
            // limitMultiFileUploadSize: 500000000, // bytes
            limitConcurrentUploads: 6,
            maxNumberOfFiles: 200,
            maxFileSize: 2501818450, // bytes
            autoUpload: true,
            url: "/uploads/",
            type: "POST",
            dropZone: $(this).find(".dropzone"),
          },
          options
        )
      ).bind("fileuploadadded", function (e, data) {
        $(e.currentTarget).find("button.cancel").removeClass("hidden");
      });

      $(document).bind("dragover", function (e) {
        var dropZone = $(".dropzone"),
          timeout = window.dropZoneTimeout;
        if (!timeout) {
          dropZone.addClass("in");
        } else {
          clearTimeout(timeout);
        }
        var found = false,
          node = e.target;
        do {
          if (node === dropZone[0]) {
            found = true;
            break;
          }
          node = node.parentNode;
        } while (node !== null);
        if (found) {
          dropZone.addClass("hover");
        } else {
          dropZone.removeClass("hover");
        }
        window.dropZoneTimeout = setTimeout(function () {
          window.dropZoneTimeout = null;
          dropZone.removeClass("in hover");
        }, 100);
      });
    },
  });
})(jQuery);
