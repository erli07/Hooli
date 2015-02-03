curl -X POST \
  -H "X-Parse-Application-Id: nLiRBbe4xwev8pUXbvD3x8Q2eQAuSg8NRQWsoo9y" \
  -H "X-Parse-REST-API-Key: fmqLkM2781ozRmKF3Fod3QbwvpUD9n2EW1LwxSmB" \
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
