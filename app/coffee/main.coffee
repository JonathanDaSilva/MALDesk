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
  $routeProvider.when('/:type/search/:search', {
    controller: 'SearchCtrl'
    templateUrl: 'views/home.html'
    resolve: {
      search: (mal, $route, $q, $rootScope) ->
        defer  = $q.defer()
        tasks  = []
        type   = $route.current.params.type
        search = $route.current.params.search

        mal.search(type, search).success (datas) ->
          for data, i in datas
            list = []
            # Full quality images
            data.image_url = data.image_url.replace('t.jpg', '.jpg')
            # Put Zero view in all
            if type == 'anime'
              data.watched_episodes = 0
              list = $rootScope.$storage.animelist
            else if type == 'manga'
              data.chapters_read = 0
              list = $rootScope.$storage.mangalist
            # Search if in anime/manga list
            for item in list
              if item.id == data.id
                datas[i] = item

          defer.resolve(datas)


        return defer.promise
    }
  })
  $routeProvider.when('/:type/:status', {
    controller: 'HomeCtrl'
    templateUrl: 'views/home.html'
  })
  $routeProvider.otherwise({
    redirectTo: '/anime/all'
  })
