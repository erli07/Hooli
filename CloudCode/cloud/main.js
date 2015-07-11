require('cloud/notification.js');
require('cloud/installation.js');
require('cloud/offer.js');
var fs = require('fs');
var layer = require('cloud/layer-parse-module/layer-module.js');
var signer = require("cloud/layer-parse-module/node_modules/jsrsasign/lib/jsrsasign.js");
var layerProviderID = 'd6b8e938-e474-11e4-a635-f1b482005d4f';
var layerKeyID = 'f61047e6-ed56-11e4-a2ee-679500000885';
var privateKey = fs.readFileSync('cloud/layer-parse-module/keys/layer-key.js');
layer.initialize(layerProviderID, layerKeyID, privateKey);

Parse.Cloud.define("generateToken", function(request, response) {
    var userID = request.params.userID;
    var nonce = request.params.nonce;
    if (!userID) throw new Error('Missing userID parameter');
    if (!nonce) throw new Error('Missing nonce parameter');
        response.success(layer.layerIdentityToken(userID, nonce));
});

//require('cloud/chat.js');