$(".add-group.button").on click: ->
  $(".ui.modal.add-group-form").modal('show')

$(".help-group.button").on click: ->
  $(".ui.modal.help-group").modal('show')

$(".message .close").on click: ->
  $(this).closest('.message').transition('fade')
