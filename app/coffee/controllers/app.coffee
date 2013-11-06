ng.controller "AppCtrl", ($rootScope, $location, $scope, $localStorage, $sessionStorage) ->

  # Routing
  $rootScope.$on "$locationChangeSuccess", (current, previous) ->
    route = $location.path().split('/')
    if route[3]?
      if route[2] == 'view' and !isNaN(route[3])
        route[3] = parseInt(route[3])
      else
        $location.path('/anime/all')

    if route[1] == 'anime' or route[1] == 'manga'
      $rootScope.type = route[1]
      $rootScope.status = route[2]
    else
      $location.path('/anime/all')


  # Initialize LocalStorage
  $rootScope.$storage = $localStorage

  # Initialize Default View
  if not $rootScope.$storage.thumbnails?
    $rootScope.$storage.thumbnails = false

  # Switch Display type
  $scope.toList = ->
    $scope.$storage.thumbnails = false
  $scope.toThumbnails = ->
    $scope.$storage.thumbnails = true

  # Check the Display Type
  $scope.isList = ->
    return { active: !$scope.$storage.thumbnails }
  $scope.isThumbnails = ->
    return { active: $scope.$storage.thumbnails }
