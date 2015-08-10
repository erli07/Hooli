curl -X POST \
  -H "X-Parse-Application-Id: MzVqMkVYVADWDerrAGGb0jHQzbKpxegpUYpU1bar" \
  -H "X-Parse-REST-API-Key: xtDZFGztY145S0cNSJ9SVs1pACCRZODb1IdATEj0" \
  -H "Content-Type: application/json" \
  -d '{
        "where": {
          "deviceType": "ios"
        },
        "data": {
          "alert": "Hi this is a push test ^_^",
          "badge": "Increment",
          "sound": "default",
	  "p": "m",
          "t": "c",
	  "fu": "123",
          "objId": "abc"
        }
      }' \
  https://api.parse.com/1/push
