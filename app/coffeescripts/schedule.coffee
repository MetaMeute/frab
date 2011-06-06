update_event_position = (event) ->
  td = $(event).parent()
  $(event).css("position", "absolute")
  $(event).css("left", td.offset().left)
  $(event).css("top", td.offset().top)

add_event_to_slot = (event, td) ->
  $(event).detach()
  $(td).append($(event))
  update_event_position(event)

$ ->
  for timeslot in $("table.room td")
    $(timeslot).droppable(
      hoverClass: "event-hover",
      drop: (event, ui) ->
        add_event_to_slot(ui.draggable, this)
        ui.draggable.data("time", $(this).data("time"))
        ui.draggable.data("room", $(this).data("room"))
        $.ajax(
          url: ui.draggable.data("update-url"),
          data: {"event": {"start_time": $(this).data("time"), "room_id": $(this).parents("table.room").data("room-id")}},
          type: "PUT",
          dataType: "script",
          success: ->
            ui.draggable.effect('highlight')
        )
    )
  for event in $("div.event")
    if $(event).data("room") and $(event).data("time")
      starting_cell = $("table[data-room='" + $(event).data("room") + "']").find("td[data-time='" + $(event).data("time") + "']")
      add_event_to_slot(event, starting_cell)
    $(event).draggable(revert: "invalid", opacity: 0.4)
  for checkbox in $("input.toggle-room")
    $(checkbox).attr("checked", true)
    $(checkbox).change ->
      $("table[data-room='" + $(this).data('room') + "']").toggle()
      for event in $("table.room div.event")
        update_event_position(event)
  $("a#hide-all-rooms").click ->
    $("input.toggle-room").attr("checked", false)
    $("table.room").hide()
  $("select#track_select").change ->
    $.ajax(
      url: $(this).parent().attr("action"),
      data: {track_id: $(this).val()},
      dataType: "html",
      success: (data) ->
        $("div#unscheduled-events").html(data)
        $("div#unscheduled-events div.event").draggable(revert: "invalid", opacity: 0.4)
    )
