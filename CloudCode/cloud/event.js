// Validate Photos have a valid owner in the "user" pointer.
Parse.Cloud.beforeSave('Event', function(request, response) {
  var currentUser = request.user;
  var objectUser = request.object.get('host');

  if(!currentUser || !objectUser) {
    response.error('An Event should have a valid host.');
  } else if (currentUser.id === objectUser.id) {
    response.success();
  } else {
    response.error('Cannot set user on Event to a user other than the current user.');
  }
});

Parse.Cloud.afterSave('Event', function(request) {
  // Only send push notifications for new activities
  if (request.object.existed()) {
    return;
  }


  var host = request.object.get("host");
  
  var event = request.object.get("event");
  
  
});


