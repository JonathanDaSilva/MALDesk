ng.controller('SidebarCtrl', ($scope, $rootScope, $location, $filter)->
  # Previous Location
  if $scope.$storage.location?
    $location.path($scope.$storage.location)

  # Routing
  $rootScope.$on("$routeChangeStart", (next, current) ->
    $scope.$emit('ShowLoader')
  )

  $rootScope.$on("$routeChangeSuccess", (current, previous) ->
    $scope.$emit('HideLoader')
    $scope.$storage.location = $location.path()
    route = $location.path().split('/')
    if route[3]?
      if route[2] == 'view' and !isNaN(route[3])
        route[3] = parseInt(route[3])
      else if route[2] == 'search' and route[3]?
        $rootScope.search = route[3]
      else
        $location.path('/anime/all')

    if route[1] == 'anime' or route[1] == 'manga'
      $rootScope.type = route[1]
      $rootScope.status = route[2]
    else
      $location.path('/anime/all')

    # Every time we change route refresh the viewx
    $rootScope.$emit('RefreshView')
  )

  # Counter badge
  $scope.counter = (type, status) ->
    lists = null

    if type == 'anime' and $scope.$storage.animelist?
      lists = $scope.$storage.animelist
    else if type == 'manga' and $scope.$storage.mangalist?
      lists = $scope.$storage.mangalist

    if lists?
      lists = $filter('status')(lists, status)
      return lists.length
    else
      return 0
)
