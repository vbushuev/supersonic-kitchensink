angular
  .module('kitchensink')
  .controller 'IndexController', ($scope, supersonic) ->

    $scope.supersonic = supersonic
