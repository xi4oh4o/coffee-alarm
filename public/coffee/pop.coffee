$(".add-group.button").on click: ->
  $(".ui.modal.add-group-form").modal('show')

$(".message .close").on click: ->
  $(this).closest('.message').transition('fade')