ng.directive('drag', () ->
  return {
    scope:
      drag: '='
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.attr('draggable', true)
      element.children('img').attr('draggable', false)
      element.css({
        'cursor': 'pointer'
      })

      element.on('dragstart', (e)->
        e.originalEvent.dataTransfer.effectAllowed = 'move'
        e.originalEvent.dataTransfer.setData('text/plain', scope.drag.id)
        e.originalEvent.dataTransfer.setData('text/json', scope.drag.watched_status)
        element.css({
          'opacity': 0.5
        })
        $('#sidebar a').each(->
          $this = $(this)
          type  = $this.attr('href').replace('#', '').split('/')[1]
        )
      )
      element.on('dragend', (e)->
        element.css({
          'opacity': 1
        })
      )

  }
)
