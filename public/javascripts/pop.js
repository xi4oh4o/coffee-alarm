$(".add-group.button").on({
  click: function() {
    return $(".ui.modal.add-group-form").modal('show');
  }
});

$(".message .close").on({
  click: function() {
    return $(this).closest('.message').transition('fade');
  }
});
