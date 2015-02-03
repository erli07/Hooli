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
