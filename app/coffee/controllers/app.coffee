ng.controller "AppCtrl", ($scope, $rootScope, $localStorage, $sessionStorage, mal, $q) ->

  # Initialize
  $rootScope.$storage = $localStorage
  $scope.ui={}
  $scope.error=0
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

  #Initialize Picker
  $rootScope.picker=
    show: false
    id:   null
    value: []

  #Picker
  $rootScope.$on('ShowPicker', (event, id)->
    $rootScope.picker.show = true
    $rootScope.picker.id   = id
  )
  $rootScope.$on('HidePicker', ->
    $scope.picker.show = false
    $scope.picker.id   = null
  )

  # Show Picker for adding chapters/episodes
  $rootScope.showPicker = (id)->
    $scope.$emit('ShowPicker', id)

  # Increase the counter chapters/episodes by one
  $rootScope.addOne = (id)->
    $rootScope.update(id, true)

  $rootScope.update = (id, increment = false)->
    $rootScope.$emit('HidePicker')
    items = $rootScope.items
    type  = $rootScope.type
    value = $scope.picker.value[type + id]
    data  = null

    for item, i in items
      if id == item.id
        if type == 'anime'
          if item.watched_episodes != item.episodes and increment
            items[i].watched_episodes++
          else if item.episodes == '-' or (item.episodes >= $scope.picker.value[type + id] and $scope.picker.value[type + id] > -1)
            items[i].watched_episodes = $scope.picker.value[type + id]

          data  = 'episodes='
          data += items[i].watched_episodes

        else if type == 'manga'
          if item.chapters_read != item.chapters and increment
            items[i].chapters_read++
          else if item.chapters == '-' or (item.chapters >= $scope.picker.value[type + id] and $scope.picker.value[type + id] > -1)
            items[i].chapters_read = $scope.picker.value[type + id]

          data  = 'chapters='
          data += items[i].chapters_read

    if data?
      mal.update(type, id, data)


