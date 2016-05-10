$(".add-group.button").on click: ->
  $(".ui.modal.add-group-form").modal('show')

$(".help-group.button").on click: ->
  $(".ui.modal.help-group").modal('show')

$(".add-user.button").on click: ->
  $(".ui.modal.add-user-form").modal('show')

$(".help-user.button").on click: ->
  $(".ui.modal.help-user").modal('show')

$(".help-alarm.button").on click: ->
  $(".ui.modal.help-alarms").modal('show')

$(".message .close").on click: ->
  $(this).closest('.message').transition('fade')

$("select.dropdown").dropdown()
