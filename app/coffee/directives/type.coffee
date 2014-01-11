ng.directive('type', ->
  return {
    restrict: 'E'
    scope:
      type: '@'
    template: '<span>{{type}}</span>'
    link: (scope, element, attrs)->
      element.addClass('label')
      if scope.type == 'Manga' or scope.type == 'TV'
        element.addClass('label-primary')
      else if scope.type == 'OAV' or scope.type == 'Novel'
        element.addClass('label-success')
      else if scope.type == 'ONA' or scope.type == 'Manwha'
        element.addClass('label-info')
      else if scope.type == 'Movie' or scope.type == 'One Shot'
        element.addClass('label-warning')
      else
        element.addClass('label-default')

  }
)
