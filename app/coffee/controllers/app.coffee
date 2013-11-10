ng.controller "AppCtrl", ($rootScope, $location, $scope, $localStorage, $sessionStorage, mal) ->

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

  # ----------------- Login -----------------
  # Initialize loggin
  delete $rootScope.$storage.user
  $scope.login =
    username: ''
    password: ''
  if $rootScope.$storage.user?
    $rootScope.userIsNotLogged = false
  else
    $rootScope.userIsNotLogged = true

  # Login function
  $scope.connect = ->
    login = $scope.login
    if login.username != '' and login.password != ''
      $scope.loginError = false
      $scope.loginWait = true
      mal.connect(login.username, login.password).then(
        -> # Sucess
          $scope.loginWait = false
          $scope.userIsNotLogged = false
          $rootScope.$storage.user = login
        ,(error)-> # Error
          $scope.loginWait = false
          $scope.loginError = true
          $scope.loginErrorMessage = "Your username or your password are not correct!"
      )
    else
      $scope.loginError = true
      $scope.loginErrorMessage = "Please fill both of the field"

  # ----------------- View -----------------
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
