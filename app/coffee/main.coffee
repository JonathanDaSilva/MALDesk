ng = angular.module("App", ['ngRoute','ngStorage','angularSpinner','ngAnimate','ngSanitize'])

ng.config ($routeProvider) ->
  $routeProvider.when('/:type/view/:id', {
    controller: 'ViewCtrl'
    templateUrl: 'views/view.html'
    resolve: {
      current: (mal, $route, $q) ->
        defer = $q.defer()
        type = $route.current.params.type
        id   = $route.current.params.id

        mal.getByIDFromCache(type, id).then(
          (data) -> # Success
            defer.resolve(data)
        )

        return defer.promise
    }
  })
  })
  $routeProvider.when('/:type/:status', {
    controller: 'HomeCtrl'
    templateUrl: 'views/home.html'
  })
  $routeProvider.otherwise({
    redirectTo: '/anime/all'
  })
