ng.controller('ToolbarCtrl', ($scope, $rootScope, $location)->
  # LogOut
  $scope.logout = ->
    $scope.$emit('ShowLoginForm')
    delete $scope.$storage.user
    $scope.$storage.animelist = []
    $scope.$storage.mangalist = []
    $scope.$storage.location = '/anime/all'
    $location.path('/anime/all')

  # Switch Display type
  $scope.toList = ->
    $scope.$storage.thumbnails = false
  $scope.toThumbnails = ->
    $scope.$storage.thumbnails = true

  # If the users have never choose
  if not $rootScope.$storage.thumbnails?
    $scope.toThumbnails()

  # Check the Display Type
  $scope.isList = ->
    return !$scope.$storage.thumbnails
  $scope.isThumbnails = ->
    return $scope.$storage.thumbnails

  # Search
  $scope.search = (type)->
    # get the search
    if type == 'anime'
      search = $scope.search.anime
    else if type == 'manga'
      search = $scope.search.manga

    $location.path("/#{type}/search/#{search}")
)
