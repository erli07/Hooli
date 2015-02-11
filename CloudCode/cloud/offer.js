// Validate Photos have a valid owner in the "user" pointer.
Parse.Cloud.beforeSave('Offer', function(request, response) {
  var currentUser = request.user;
  var objectUser = request.object.get('user');

  if(!currentUser || !objectUser) {
    response.error('An Offer should have a valid user.');
  } else if (currentUser.id === objectUser.id) {
    response.success();
  } else {
    response.error('Cannot set user on Offer to a user other than the current user.');
  }
});

Parse.Cloud.afterSave('Offer', function(request) {
  // Only send push notifications for new activities
  if (request.object.existed()) {
    return;
  }

  var toUser = request.object.get("toUser");
  if (!toUser) {
    throw "Undefined toUser. Skipping push for Activity " + request.object.get('type') + " : " + request.object.id;
    return;
  }

  var fromUser = request.object.get("user");
  
  var offer = request.object.get("offer");
  
  
});


