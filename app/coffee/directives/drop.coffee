ng.directive('drop', ($routeParams) ->
  return {
    scope:
      drop: '='
    restrict: 'A'
    link: (scope, element, attrs) ->
      data   = element.attr('href').replace('#', '').split('/')
      element.attr('droppable', false)
      type   = data[1]
      status = data[2]

      element.on('dragover', (e)->
        e.preventDefault()
        if $routeParams.type == type and e.originalEvent.dataTransfer.getData('text/json') != status
          element.attr('droppable', true)
          element.addClass('dragover')
        else
          e.originalEvent.dataTransfer.dropEffect = 'none'

      )
      element.on('dragleave', (e)->
        e.preventDefault()
        if $routeParams.type == type and e.originalEvent.dataTransfer.getData('text/json') != status
          element.attr('droppable', false)
          element.removeClass('dragover')
      )
      element.on('drop', (e)->
        e.preventDefault()
        # Default style
        element.attr('droppable', false)
        element.removeClass('dragover')
        # Search the anime/manga drop
        id = e.originalEvent.dataTransfer.getData('text/plain')
        id = parseInt(id)

        # execute the function in the parameters
        scope.drop(id, type, status)
      )
  }
)
