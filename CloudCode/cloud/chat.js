Parse.Cloud.beforeSave('Chat', function(request, response) {
  var currentUser = request.user;
  var objectUser = request.object.get('fromUser');

  if(!currentUser || !objectUser) {
    response.error('An Chat should have a valid fromUser.');
  } else if (currentUser.id === objectUser.id) {
    response.success();
  } else {
    response.error('Cannot set fromUser on Chat to a user other than the current user.');
  }
});

Parse.Cloud.afterSave('Chat', function(request) {
  // Only send push notifications for new activities
  if (request.object.existed()) {
    return;
  }

  var toUser = request.object.get("toUser");
  if (!toUser) {
    throw "Undefined toUser. Skipping push for Activity " + request.object.get('type') + " : " + request.object.id;
    return;
  }


  var query = new Parse.Query(Parse.Installation);
  query.equalTo('user', toUser);

  Parse.Push.send({
    where: query, // Set our Installation query.
    data: alertPayload(request)
  }).then(function() {
    // Push was successful
    console.log('Sent push.');
  }, function(error) {
    throw "Push Error " + error.code + " : " + error.message;
  });
});

var alertMessage = function(request) {
  var message = "";

    if (request.user.get('username')) {
      message = request.user.get('username') + ': ' + request.object.get('content').trim();
    } else {
      message = "Someone send you a message.";
    }


  // Trim our message to 140 characters.
  if (message.length > 140) {
    message = message.substring(0, 140);
  }

  return message;
}

var alertPayload = function(request) {
  var payload = {};

    return {
      alert: alertMessage(request), // Set our alert message.
      badge: 'Increment', // Increment the target device's badge count.
      // The following keys help Anypic load the correct photo in response to this push notification.
	  sound: 'default',
      p: 'm', // Payload Type: Activity
      fu: request.object.get('fromUser').id, // From User
      objId: request.object.id // Photo Id
    };

}
