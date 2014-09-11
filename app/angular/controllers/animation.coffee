angularApp = angular.module 'angularApp', ['ngTouch']

angularApp.controller 'AnimationCtrl', ($scope)->

  alert('OKKK')

  steroids.view.navigationBar.show "Animation"

  $scope.animationSpeed = 0.6

  $scope.performAnimation = (transition) ->

    anim = new steroids.Animation
      transition: transition
      duration: $scope.animationSpeed

    anim.perform()
