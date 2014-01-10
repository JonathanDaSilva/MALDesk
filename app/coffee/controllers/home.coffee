ng.controller "HomeCtrl", ($rootScope, mal)->

  $rootScope.$on('RefreshView', ->
    if $rootScope.type == "anime"
      $rootScope.items = $rootScope.$storage.animelist
    else
      $rootScope.items = $rootScope.$storage.mangalist
  )


  # Refreshing the first time
  $rootScope.$emit('RefreshView')

