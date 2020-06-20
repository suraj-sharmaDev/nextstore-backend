var admin = require("firebase-admin");

var serviceAccount = require("../config/nextstore-firebase.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://nextstore-fb30e.firebaseio.com"
});

var options = {
	priority: "normal",
	timeToLive: 60 * 60  //1 hour validity
};

const createPayload = (type) => {
	var payload = {};
	switch (type) {
		case 'new_order':
			payload = {
				notification: {
					title: "New Order",
					body: "You have received a new order!"
				}
			};
			break;
		default:
			payload = {
				notification: {
					title: "New notification",
					body: "You have received a new notification!"
				}
			};
			break;
	}
	return payload;
}

const sendMessage = (fcmToken, type) => {
	var error = true;
	admin.messaging().sendToDevice(fcmToken, createPayload(type), options)
	.then(function(response) {
		error = false;
		console.log("Successfully sent message:", response);
	})
	.catch(function(error) {
		console.log("Error sending message:", error);
	});	
	return error;
}
module.exports = sendMessage;