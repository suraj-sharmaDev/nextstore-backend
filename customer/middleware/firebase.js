var admin = require("firebase-admin");

var serviceAccount = require("../config/nextstore-firebase.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://nextstore-fb30e.firebaseio.com"
});

module.exports.firebase = admin