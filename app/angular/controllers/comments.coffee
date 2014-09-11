commentsApp = angular.module 'commentsApp', ['CommentsModel', 'ngTouch']

commentsApp.controller 'CommentsCtrl', ($scope, $timeout, $interval, Comments, user)->

  related_item_id = _.random(0, 10000000)

  $scope.currentUser = user.generateUser()

  $scope.comments = []

  processComments = (comments) ->
    for comment in comments
      comment.created_at_formatted = moment(comment.created_at).calendar()
      #$scope.remove(comment)
    $timeout ->
      $scope.comments = comments


  loadComments = ->
    Comments
      .findAll()
      .then processComments

  loadComments()

  #$interval loadComments, 2000

  $scope.remove = (comment) ->
    if comment.user_id isnt $scope.currentUser?.user_id
      return

    comment.removed = true
    comment.error = false
    comment.removeFailed = false

    removeFailed = ->
      comment.removed = false
      comment.error = "Delete failed, try again"
      comment.removeFailed = true

    $timeout removeFailed, 3000

    Comments
      .remove(comment.id)
      .then loadComments, removeFailed

  saveComment = (comment, clonedComment) ->
    if comment.failed
      delete comment.failed
    if comment.error
      delete comment.error

    if clonedComment
      if clonedComment.failed
        delete clonedComment.failed
      if clonedComment.error
        delete clonedComment.error
      clonedComment.notYetSaved = true


    saveFailed = ->
      comment.failed = true
      comment.notYetSaved = false
      comment.error = "Posting failed, try again"

      if clonedComment
        clonedComment.failed = true
        clonedComment.notYetSaved = false
        clonedComment.error = "Posting failed, try again"


    #$timeout saveFailed, 3000

    Comments
      .create(comment)
      .then loadComments, saveFailed

  $scope.retrySave = (comment) ->
    comment.notYetSaved = true
    saveComment(comment)

  $scope.add = ->
    message = $scope.message

    if !message || !$scope.currentUser?.user_id
      return

    {user_id, user_name, user_image_url} = $scope.currentUser

    created_at = new Date().getTime()

    comment = {
      related_item_id
      user_id
      user_name
      user_image_url
      message
      created_at
    }

    clonedComment = _.clone(comment)
    clonedComment.notYetSaved = true
    $scope.comments.push(clonedComment)

    processComments($scope.comments)


    $scope.message = ''
    document.getElementsByTagName("input")[0].blur()

    saveComment(comment, clonedComment)
