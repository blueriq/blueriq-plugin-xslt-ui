(function() {

	var validations = {};

	$(function() {
		Runtime.attachFileUploads();
	});

Runtime.attachFileUploads = function attachFileUploads() {
	$('.aq-fileupload').each(function(index, element) {
		// Elements
		var fileUploadElement = $(element);
		var labelElement = fileUploadElement.find('.fileUploadLabel');
		var inputElement = fileUploadElement.find('.fileUploadInput');
		var progressBar = fileUploadElement.find('.progress');
		var descriptionElement = fileUploadElement.find('.fileUploadDescription');
		var invalidFileTableElement = fileUploadElement.find('.invalidFileTable');
		var invalidFileTableCaption = invalidFileTableElement.find('.invalidFileTableCaption');
		// Properties
		var url = fileUploadElement.data('url');
		var singleFileMode = fileUploadElement.data('singlefilemode');
		var allowedExtensions = fileUploadElement.data('allowedextensions');
		var maxFileSize = fileUploadElement.data('maxfilesize');
		var singleUploadLabel = fileUploadElement.data('singleuploadlabel');
		var multiUploadLabel = fileUploadElement.data('multiuploadlabel');
		var fileSizeDescription = fileUploadElement.data('filesizedescription');
		var extensionDescription = fileUploadElement.data('extensiondescription');
		var fileSizeValidationMessage = fileUploadElement.data('filesizevalidationmessage');
		var extensionValidationMessage = fileUploadElement.data('extensionvalidationmessage');
		var uploadFailedMessage = fileUploadElement.data('uploadfailedmessage');

		attachFileUpload(fileUploadElement, labelElement, inputElement, descriptionElement, {
			'url': url,
			'allowedExtensions': allowedExtensions,
			'maxFileSize': maxFileSize,
			'singleFileMode': singleFileMode,
			'singleUploadLabel': singleUploadLabel,
			'multiUploadLabel': multiUploadLabel,
			'fileSizeDescription': fileSizeDescription,
			'extensionDescription': extensionDescription,
			'fileSizeValidationMessage': fileSizeValidationMessage,
			'extensionValidationMessage': extensionValidationMessage,
			'fileUploadErrorHandler': function(jsonData) {
				if(jsonData && jsonData.message){
					invalidFileTableCaption.text(jsonData.message);
				}else{
					invalidFileTableCaption.text('Error uploading file.');
				}
				invalidFileTableElement.show();
				progressBar.hide();
			},
			'fileAddedHandler': function(file) {
				if(!file.isValid) {
					if(!invalidFileTableElement.is(':visible')) {
						invalidFileTableCaption.text(uploadFailedMessage);
						invalidFileTableElement.show();
					}
					var fileEntry = '<tr><td class="fileInfo">' +
									file.name + ' (' + file.size +
									')</td><td class="fileError text-error">' +
									file.errorMessage +
									'</td></tr>';
					invalidFileTableElement.append(fileEntry);
					validations[element.id] = invalidFileTableElement.html();
				}
			},
			'uploadStartHandler': function uploadStartHandler(data) {
				invalidFileTableElement.find('tbody').empty()
			},
			'uploadDoneHandler': function(data) {
				progressBar.hide();

				delete validations[element.id];
				Runtime.handleComposedResult(data);
				Runtime.attachFileUploads();
			},
			'progressPercentageHandler': function(data) {
				if(!progressBar.is(':visible')) {
					progressBar.show();
				}
				progressBar.find('.bar').width(data + '%');
			}
		});

		// Initial hiding
		if (!validations[element.id]){
			invalidFileTableElement.hide();
		}else{
			invalidFileTableElement.html(validations[element.id]);
		}
		progressBar.hide();
	});
};

var attachFileUpload = function attachFileUpload(element, labelElement, inputElement, descriptionElement, configuration) {
	$(document).bind('drop dragover', function (e) {
	    e.preventDefault();
	});

	// Input checking
	if(!element) {
		throw new Error('bqFileUpload: element is mandatory');
	}
	if(!labelElement) {
		throw new Error('bqFileUpload: labelElement is mandatory')
	}
	if(!inputElement) {
		throw new Error('bqFileUpload: inputElement is mandatory')
	}
	if(!configuration || !configuration.url) {
		throw new Error('bqFileUpload: url is mandatory');
	}

	// Utility functions
	var formatFileSize = function formatFileSize(bytes) {
	    if (typeof bytes !== 'number') { return ''; }
	    if (bytes >= 1000000000) { return (bytes / 1000000000).toFixed(2) + ' GB'; }
	    if (bytes >= 1000000) { return (bytes / 1000000).toFixed(2) + ' MB'; }
	    return (bytes / 1000).toFixed(2) + ' KB';
	};

	var formatBitrate = function formatBitrate(bits) {
		if (typeof bits !== 'number') { return ''; }
	    if (bits >= 1000000000) { return (bits / 1000000000).toFixed(2) + ' Gbit/s'; }
	    if (bits >= 1000000) { return (bits / 1000000).toFixed(2) + ' Mbit/s'; }
	    if (bits >= 1000) { return (bits / 1000).toFixed(2) + ' kbit/s'; }
	    return bits.toFixed(2) + ' bit/s';
	};

	var formatTime = function formatTime(seconds) {
	    var date = new Date(seconds * 1000), days = Math.floor(seconds / 86400);
	    days = days ? days + 'd ' : '';
	    return days + ('0' + date.getUTCHours()).slice(-2) + ':' + ('0' + date.getUTCMinutes()).slice(-2) + ':' + ('0' + date.getUTCSeconds()).slice(-2);
	};

	var formatPercentage = function formatPercentage(floatValue) {
	    return (floatValue * 100).toFixed(2);
	};

	// Set text on UI elements
	if(configuration.singleFileMode) {
		labelElement.text(configuration.singleUploadLabel);
	} else {
		labelElement.text(configuration.multiUploadLabel);
		inputElement.attr("multiple", "multiple");
	}

	if(descriptionElement) {
		var description = '';
		if(configuration.fileSizeDescription && configuration.maxFileSize) {
			description += configuration.fileSizeDescription.replace('{0}', formatFileSize(configuration.maxFileSize));
		}
		if(configuration.extensionDescription && configuration.allowedExtensions) {
			if(configuration.fileSizeDescription && configuration.maxFileSize) {
				description += ' / ';
			}
			description += configuration.extensionDescription.replace('{0}', configuration.allowedExtensions.split('|').join(', '));
		}
		descriptionElement.text(description);
	}

	// Set messages and settings for upload component
	var messages = {};
    if(configuration.extensionValidationMessage) {
    	messages.acceptFileTypes = configuration.extensionValidationMessage;
    }
    if(configuration.fileSizeValidationMessage) {
    	messages.maxFileSize = configuration.fileSizeValidationMessage;
    }

	var settings = {
		url: configuration.url,
		singleFileUploads: false,
		dropZone: element,
        messages: messages,
        formData: function(form) {
        	var pageEvent = {'elementKey': element.attr('id'), 'parameters': {}, 'fields': gatherFields(form)};
        	return [{name: "pageEvent", value: JSON.stringify(pageEvent)}, {name: 'X-CSRF-Token', value: getCsrfToken(form)}];
        }
	};

	// something like: "[{"key":"P416-C0-F1","values":["field_value"]}, ...]"
	function gatherFields(form) {
		var fields = [];
		// form.children('.aq-input') does not seem to work
		$.each($('#' + form.attr('id') + ' .aq-input'), function(i, elem) {
			fields.push({'key': $(elem).attr("id"), 'values': [$(elem).val()]});
		});
		return fields;
	}

	function getCsrfToken(form) {
		var formInputs = form.serializeArray();
		if(formInputs && formInputs.length >0) {
			for(var i=0; i < formInputs.length; i++) {
				if(formInputs[i].name === 'X-CSRF-Token'){
					return formInputs[i].value;
				}
			}
		}
		return '';
	}

	if(configuration.allowedExtensions) {
		settings['acceptFileTypes'] = new RegExp('(' + configuration.allowedExtensions + ')$', 'i');
	}
	if(configuration.maxFileSize) {
		settings['maxFileSize'] = configuration.maxFileSize;
	}

	// Create upload component
	var fileUpload = element.fileupload(settings);

	// Set callback handlers
	fileUpload.on('fileuploadprocessalways', function (e, data) {
		if(configuration.fileAddedHandler) {
			var selectedFile = data.files[data.index];
			var file = {
				name : selectedFile.name,
				size : formatFileSize(selectedFile.size),
				isValid : !selectedFile.error,
				errorMessage : selectedFile.error
			}
			configuration.fileAddedHandler(file);
		}
	});

	// Set callback handlers
	fileUpload.on('fileuploadfail', function (e, data) {
		if(data.response().jqXHR && data.response().jqXHR.responseText){
			var jsonResponse = JSON.parse(data.response().jqXHR.responseText);
			configuration.fileUploadErrorHandler(jsonResponse);
		} else {
			configuration.fileUploadErrorHandler('Error uploading file');
		}

	});

	fileUpload.on('fileuploadadd', function(e, data) {
		// Callback on start of (multiple) file upload
		if(configuration.uploadStartHandler) {
			configuration.uploadStartHandler(data.response().result);
		}
	});

	fileUpload.on('fileuploadsend', function(e, data) {
		var doUpload = true;
		for (var i = 0; i < data.files.length; i++) {
			var file = data.files[i];
			if (file.error) {
				upload = false;
				break;
			}
		}
		return doUpload;
	});

	fileUpload.on('fileuploadprogressall', function (e, data) {
		if(configuration.progressPercentageHandler) {
			configuration.progressPercentageHandler(parseInt(data.loaded / data.total * 100, 10));
		}
		if(configuration.progressUploadSpeedHandler) {
			configuration.progressUploadSpeedHandler(formatBitrate(data.bitrate));
		}
		if(configuration.progressRemainingTimeHandler) {
			configuration.progressRemainingTimeHandler(formatTime((data.total - data.loaded) * 8 / data.bitrate));
		}
		if(configuration.progressRemainingFileSizeHandler) {
			configuration.progressRemainingFileSizeHandler(formatFileSize(data.loaded));
		}
		if(configuration.progressUploadedFileSizeHandler) {
			configuration.progressUploadedFileSizeHandler(formatFileSize(data.total));
		}
    });

    fileUpload.on('fileuploaddone', function(e, data) {
		if(configuration.uploadDoneHandler) {
			// Check response type for IE support
			var responseContentType = data.response().jqXHR.getResponseHeader('Content-type');

			if(!responseContentType || responseContentType.indexOf('application/json') === -1) {
				try {
					// Browser doesn't support XHR request for file upload
					var response = data.response();
					var jsonText;

					if(response.result instanceof Object) {
						// Get JSON text from inner node
						jsonText = response.result[0].childNodes[1].innerText;
					}
					else {
						jsonText = response.result;
					}
					// Pass data as true JSON
					configuration.uploadDoneHandler(jQuery.parseJSON(jsonText));
				}
				catch(e) {
					console.error("Error during file upload response handling: " + e);
				}
			}
			else {
				configuration.uploadDoneHandler(data.response().result);
			}
		}
	});
};
})();
