ng.directive 'actual', ($location,$rootScope) ->
  return {
    restrict: 'A'
    link: (scope, element, attrs) ->
      parent = element.parent()
      href = attrs.href.replace(/#/g, '')
      $rootScope.$on '$locationChangeSuccess', ->
        if href == $location.path()
          parent.addClass('active')
        else
          parent.removeClass('active')
  }
