ng.controller('SidebarCtrl', ($scope, $rootScope, $location, $filter, mal)->
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

  # Drop
  $scope.dropitem = (id, type, status)->
    execute = null
    list    = null
    found   = null

    # Get the right list
    if type == 'anime'
      list = $rootScope.$storage.animelist
    else
      list = $rootScope.$storage.mangalist

    # Found the anime/manga
    for item, i in list
      if item.id == id
        found = i
        break

    if status == 'completed'
      error = false
      if found?
        if type == 'anime'
          view = list[i].watched_episodes
          max  = list[i].episodes
        else
          view = list[i].read_chapters
          max  = list[i].chapters
        if view == max
          execute = true
        else
          error = true
      else
          error = true

      if error
        donothing = null
        #TODO: ask the user if he is sure to make that
    else if status == 'plantowatch' or status == 'plantoread'
      if found?
        if type == 'anime'
          view = list[i].watched_episodes
        else
          view = list[i].read_chapters
        if view == 0
          execute = true
        else
          #TODO: ask the user if he is sure to make that
      else
        execute = true
    else if status == 'watching' or status == 'onhold'
      if found?
        if type == 'anime'
          actualstatus = list[i].watched_status
        else
          actualstatus = list[i].read_status
        if actualstatus != 'completed'
          execute = true
        else
          #TODO: ask the user if he is sure to make that
      else
        execute = true

    else
      execute = true

    if execute
      data = ''
      if found?
        if type == 'anime'
          $rootScope.$storage.animelist[found].watched_status = status
          data = "episodes=#{$rootScope.$storage.animelist[found].watched_episodes}"
        else
          $rootScope.$storage.mangalist[found].read_status = status
          data  = "chapters=#{$rootScope.$storage.animelist[found].chapters_read}"
          data += "&volumes=#{$rootScope.$storage.animelist[found].volumes_read}"

        # Refresh the view
        $rootScope.$emit('RefreshView')

        data += "&status=#{status}"
        # Put data to MAL
        mal.update(type, id, data)
     else
      donothing = null
      #TODO: when not in anime/manga list
)
