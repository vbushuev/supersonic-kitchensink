animationApp = angular.module 'animationApp', ['ngTouch']

animationApp.controller 'AnimationCtrl', ($scope)->

  steroids.view.navigationBar.show "Animation"

  $scope.animationSpeed = 0.6

  $scope.performAnimation = (transition) ->

    anim = new steroids.Animation
      transition: transition
      duration: $scope.animationSpeed

    anim.perform()
