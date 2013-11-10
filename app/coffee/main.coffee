ng = angular.module("App", ['ngRoute','ngStorage','angularSpinner'])


ng.config ($routeProvider) ->
  $routeProvider.when('/:type/view/:id', {
    controller: 'ViewCtrl'
    templateUrl: 'views/view.html'
  })
  $routeProvider.when('/:type/:status',{
    controller: 'HomeCtrl'
    templateUrl: 'views/home.html'
  })
  $routeProvider.otherwise({
    redirectTo: '/anime/all'
  })
