greenEggs = angular.module('greenEggs', ['ngResource'])

greenEggs.controller('GECtrl', function LJCtrl($scope, Data, $resource, $routeParams, $location) {

  $scope.isActive = function(route) {
    return route === $location.path()
  }

})
