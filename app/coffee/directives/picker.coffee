ng.directive('picker', ->
  return {
    restrict: 'E'
    scope:
      model:   '='
      item:    '='
      clickOk: '&'
    template: '<form class="picker" ng-submit="clickOk()"><input autofocus type="number" min="0" ng-model="model"/><input type="submit" value="Ok"/></form>'
    link: (scope, element, attrs) ->
      input = element.children('input')
      max = attrs.max

      if scope.item.watched_episodes?
        scope.model = scope.item.watched_episodes
      if scope.item.chapters_read?
        scope.model = scope.item.chapters_read

      scope.$watch('model', ->
        if scope.model > max or scope.model < 0
          scope.model = max
      )
      if max != '-'
        input.attr('max', max)
  }
)
