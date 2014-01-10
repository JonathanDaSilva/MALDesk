ng.controller "AppCtrl", ($rootScope, $location, $scope, $localStorage, $sessionStorage, mal, $filter, $q) ->

  # Initialize
  $rootScope.$storage = $localStorage
  $scope.ui={}
  $scope.error=0
  $rootScope.picker=
    show: false
    id:   null
    value: []
  $scope.login=
    username: ''
    password: ''

  # Event, Function for variable
  #LoginForm
  $scope.isNotConnect = ->
    return !!$scope.ui.login
  $scope.$on('ShowLoginForm', ->
    $scope.ui.login = true
  )
  $scope.$on('UserLogged', ->
    $scope.ui.login = false
  )
  $scope.$on('CleanLoginForm', ->
    $scope.login =
      username: ''
      password: ''
  )
  #LoginError
  $scope.$on('LoginError', ->
    $scope.loginError = true
    $scope.loginErrorMessage = "Your username or your password are not correct!"
  )
  $scope.$on('FieldEmpty', ->
    $scope.loginError = true
    $scope.loginErrorMessage = "Please fill both of the field"
  )
  $scope.$on('LoadFail', ->
    $scope.loginError = true
    $scope.loginErrorMessage = "Impossible to request your anime/manga list"
  )
  #Spinner
  $scope.$on('ShowLoader', ->
    $scope.ui.spinner = true
  )
  $scope.$on('HideLoader', ->
    $scope.ui.spinner = false
  )
  $scope.ifLoading = ->
    return !!$scope.ui.spinner

  # LogOut
  $scope.logout = ->
    $scope.$emit('ShowLoginForm')
    delete $scope.$storage.user
    $scope.$storage.animelist = []
    $scope.$storage.mangalist = []
    $location.path('/anime/all')

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


  # If Already Connect
  if $rootScope.$storage.user?
    $scope.$emit('HideLoginForm')
    mal.setAccount($rootScope.$storage.user)
  else
    $scope.$emit('ShowLoginForm')

  # Login function trigger on login click
  $scope.connect = ->
    # If the users has fill both field
    if $scope.login.username != '' and $scope.login.password != ''
      $scope.$emit('ShowLoader')
      mal.connect($scope.login.username, $scope.login.password).then(
        -> # Sucess
          # Set the account
          mal.setAccount($scope.login)
          $scope.$storage.user = $scope.login
          $scope.$emit('CleanLoginForm')
          $scope.$emit('UserLogged')
          $scope.$emit('HideLoader')
          # Get Anime/Manga Lists
          $scope.$emit('GetLists')
        ,-> # Error
          $scope.$emit('LoginError')
          $scope.$emit('HideLoader')
      )
    else
      $scope.$emit('FieldEmpty')

  # Get Anime/Manga Lists
  $scope.$on('GetLists', ->
    $scope.$emit('ShowLoader')
    $q.all([
      mal.getAnimeList()
      mal.getMangaList()
    ]).then(
      (data) -> #Success
        $scope.$storage.animelist = data[0]
        $scope.$storage.mangalist = data[1]
        $scope.$emit('HideLoader')
        $rootScope.$emit('RefreshView')
      ,->
        if $scope.error != 3
          $scope.error++
          $scope.$emit('GetLists') #Try Again
        else
          delete $scope.$storage.user
          $scope.$emit('HideLoader')
          $scope.$emit('ShowLoginForm')
          $scope.$emit('LoadFail')
    )
  )

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

  # Counter
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
