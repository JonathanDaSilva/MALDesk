ng.directive('actual', ($location) ->
  return {
    restrict: 'A'
    link: (scope, element, attrs) ->
      parent = element.parent()
      href = attrs.href.replace(/#/g, '')
      scope.$on '$locationChangeSuccess', ->
        if href == $location.path()
          parent.addClass('active')
        else
          parent.removeClass('active')
  }
)
