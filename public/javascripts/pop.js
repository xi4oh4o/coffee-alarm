$(".add-group.button").on({
  click: function() {
    return $(".ui.modal.add-group-form").modal('show');
  }
});

$(".help-group.button").on({
  click: function() {
    return $(".ui.modal.help-group").modal('show');
  }
});

$(".add-user.button").on({
  click: function() {
    return $(".ui.modal.add-user-form").modal('show');
  }
});

$(".help-user.button").on({
  click: function() {
    return $(".ui.modal.help-user").modal('show');
  }
});

$(".help-alarm.button").on({
  click: function() {
    return $(".ui.modal.help-alarms").modal('show');
  }
});

$(".message .close").on({
  click: function() {
    return $(this).closest('.message').transition('fade');
  }
});

$("select.dropdown").dropdown();
