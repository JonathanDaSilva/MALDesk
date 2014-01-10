ng.controller 'ViewCtrl', (current, $scope) ->
  if current.data?
    $scope.current = current.data
  else
    $scope.current = current
