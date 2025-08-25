function restoreDraftFile(inputEl, fileName, attachmentDescription, attachmentToken, attachmentPath) {
// Base on the original addFile function
const attachmentsFields = $(inputEl).closest('.attachments_form').find('.attachments_fields');
const addAttachment = $(inputEl).closest('.attachments_form').find('.add_attachment');
const maxFiles = ($(inputEl).attr('multiple') == 'multiple' ? 10 : 1);

const attachmentId = restoreDraftFile.nextAttachmentId++;
addFile.nextAttachmentId = attachmentId + 1;

const fileSpan = $('<span>', { id: 'attachments_' + attachmentId });
let param = $(inputEl).data('param');
if (!param) {param = 'attachments'};

fileSpan.append(
    $('<input>', { type: 'text', 'class': 'icon icon-attachment filename readonly', name: param +'[' + attachmentId + '][filename]', readonly: 'readonly'} ).val(fileName),
    $('<input>', { type: 'text', 'class': 'description', name: param + '[' + attachmentId + '][description]', maxlength: 255, placeholder: $(inputEl).data('description-placeholder') } ).val(attachmentDescription),
    $('<input>', { type: 'hidden', 'class': 'token', name: param + '[' + attachmentId + '][token]'} ).val(attachmentToken),
    $('<a>&nbsp</a>').attr({ href: "#", 'class': 'icon-only icon-del remove-upload' }).click(removeFile).attr({
        "data-remote": true,
        "data-method": 'delete',
        href: attachmentPath
        })
        .off('click')
).appendTo(attachmentsFields);

if ($(inputEl).data('description') == 0) {
fileSpan.find('input.description').remove();
}

addAttachment.toggle(attachmentsFields.children().length < maxFiles);
return attachmentId;
}
restoreDraftFile.nextAttachmentId = 1;
